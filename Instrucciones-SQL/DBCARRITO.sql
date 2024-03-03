


create database DBCARRITO

GO

USE	DBCARRITO

GO

CREATE TABLE CATEGORIA (
IdCategoria int primary key identity,
Descripcion varchar(100),
Activo bit default 1,
FechaRegistro datetime default getdate ()
)

GO

CREATE TABLE MARCA(
IdMarca int primary key identity,
Descripcion varchar (100),
Activo bit default 1,
FechaRegistro datetime default getdate ()
)

go

CREATE TABLE PRODUCTO(
IdProducto int primary key identity,
Nombre varchar (100),
Descripcion varchar (100),
IdMarca int references Marca (IdMarca),
IdCategoria int references Categoria (IdCategoria),
Precio decimal (10,2) default 0,
Stock int,
RutaImagen varchar (100),
NombreImagen varchar (100),
Activo bit default 1,
FechaRegistro datetime default getdate ()

)

GO

CREATE TABLE CLIENTE(
IdCliente int primary key identity,
Nombres varchar (100),
Apellidos varchar (100),
Correo varchar (100),
Clave varchar (150),
Reestablecer bit default 0,
FechaRegistro datetime default getdate ()
)

go

CREATE TABLE CARRITO(
IdCarrito int primary key identity,
IdCliente int references CLIENTE (IdCliente),
IdProducto int references PRODUCTO (IdProducto),
Cantidad int
)

go

CREATE TABLE VENTA(
IdVenta int primary key identity,
IdCliente int references CLIENTE (IdCliente),
TotalProducto int,
MontoTotal decimal (10,2),
Contacto varchar (50),
IdDistrito varchar (10),
Telefono varchar (50),
Direccion varchar (500),
IdTransaccion varchar (50),
FechaVenta datetime default getdate ()
)

go

CREATE TABLE DETALLE_VENTA (
IdDetalleVenta int primary key identity,
IdVenta int references Venta (IdVenta),
IdProducto int references PRODUCTO (IdProducto),
Cantidad int,
Total decimal (10,2)
)

go

CREATE TABLE USUARIO (
IdUsuario int primary key identity,
Nombres varchar (100),
Apellidos varchar (100),
Correo varchar (100),
Clave varchar (150),
Reestablecer bit default 1,
Activo bit default 1,
FechaRegistro datetime default getdate ()
)

go

CREATE TABLE PROVINCIA(
IdDepartamento varchar (2) NOT NULL,
Descripcion varchar (50) NOT NULL
)

go 

CREATE TABLE CIUDAD(
IdProvincia varchar (4) NOT NULL,
Descripcion varchar (45) NOT NULL,
IdDepartamento varchar (2) NOT NULL
)

go

CREATE TABLE BARRIO (
IdDistrito varchar (96) NOT NULL,
Descripcion varchar (45) NOT NULL,
IdProvincia varchar (4) NOT NULL,
IdDepartamento varchar (2) NOT NULL
)

insert into USUARIO (Nombres, Apellidos, Correo, Clave) values	('Admin', 'Admin', 'admin@gmail.com','4813494d137e1631bba301d5acab6e7bb7aa74ce1185d456565ef51d737677b2')

	
	insert into CATEGORIA(Descripcion)values 
	('Tecnologia'),
	('Alimentos'),
	('Deportes'),
	('Cosmeticos')

	
	insert into MARCA(Descripcion)values 
	('SONY'),
	('NESTLE'),
	('KELLOG'),
	('DOVE'),
	('ADIDAS'),
	('NIKE')


	Select * from PROVINCIA;
	insert into  PROVINCIA(IdDepartamento, Descripcion)
	values 
	('01','Pichincha'),
	('02','Guayas'),
	('03','Esmeraldas')


	select * from CIUDAD;
	insert into CIUDAD (IdProvincia, Descripcion, IdDepartamento)
	values
	('0101', 'Quito', '01'),
	('0102', 'Pedro Moncayo', '01'),


	('0201', 'Guayaquil', '02'),
	('0202', 'Milagro', '02'),


	('0301', 'Atacames', '03'),
	('0302', 'Tonsupa', '03')

	

	INSERT INTO BARRIO(IdDistrito, Descripcion, IdProvincia, IdDepartamento) values
	('010101', 'Solanda', '0101', '01'),
	('010102', 'La Magdalena', '0101', '01'),

	('010201', 'Tocachi', '0102', '01'),



	('020101', 'Sauces', '0201', '02'),

	('020201', '24 de Mayo', '0202', '02'),



	('030101', 'Atacames Centro', '0301', '03'),

	('030201', 'Tonsupa Centro', '0302', '03')


	--METODOS_USUARIO
	
	create proc sp_RegistrarUsuario(
	@Nombres varchar (100),
	@Apellidos varchar (100),
	@Correo varchar (100),
	@Clave varchar (100),
	@Activo bit,
	@Mensaje varchar (500) output,
	@Resultado int output
	)
	as
	begin
		SET @Resultado = 0

	IF NOT EXISTS (SELECT * FROM USUARIO WHERE Correo = @Correo)
	begin
		insert into USUARIO (Nombres,Apellidos,Correo,Clave,Activo)values
		(@Nombres,@Apellidos,@Correo,@Clave,@Activo)

		SET @Resultado= scope_identity()
		end
		else
		set	@Mensaje = 'El correo del usuario ya existe'
	end

	create proc sp_EditarUsuario(
	@IdUsuario int,
	@Nombres varchar (100),
	@Apellidos varchar (100),
	@Correo varchar (100),
	@Activo bit,
	@Mensaje varchar (500) output,
	@Resultado int output
	)
	as
	begin
		SET @Resultado = 0
		IF  NOT EXISTS (SELECT * FROM USUARIO WHERE Correo = @Correo and IdUsuario != @IdUsuario)
	begin 

		update top (1) USUARIO set 
		Nombres = @Nombres,
		Apellidos = @Apellidos,
		Correo = @Correo,
		Activo = @Activo
		where IdUsuario = @IdUsuario

		SET @Resultado = 1
		end	
	else 
		set @Mensaje = 'El correo del usuario ya existe'
	end


	--METODOS_CATEGORIA

create proc sp_RegistrarCategoria(
@Descripcion varchar (100),
@Activo bit,
@Mensaje varchar (500) output,
@Resultado int output
)
as
begin
	SET @Resultado = 0 
	IF NOT EXISTS (SELECT * FROM CATEGORIA WHERE Descripcion = @Descripcion)
	begin
		insert into CATEGORIA (Descripcion, Activo) values 
		(@Descripcion,@Activo)
	
	SET @Resultado = scope_identity()
	end
	 else
	set @Mensaje = 'La categoria ya existe'
end


create proc sp_EditarCategoria(
@IdCategoria int,
@Descripcion varchar (100),
@Activo bit,
@Mensaje varchar (500) output,
@Resultado bit output
)
as
begin
	SET @Resultado = 0
	IF NOT EXISTS (SELECT * FROM CATEGORIA WHERE Descripcion = @Descripcion and IdCategoria != @IdCategoria)
	begin

			update top (1) CATEGORIA set
			Descripcion = @Descripcion,
			Activo = @Activo
			where IdCategoria = @IdCategoria

			SET @Resultado = 1
		end
		else
		set @Mensaje = 'La categoria ya existe'
end


create proc sp_EliminarCategoria(
@IdCategoria int,
@Mensaje varchar (500) output,
@Resultado bit output
)
as 
begin
	SET @Resultado = 0
	IF NOT EXISTS (select * from PRODUCTO p
	inner join CATEGORIA c on c.IdCategoria = p.IdCategoria
	where p.IdCategoria = @IdCategoria)
	begin
		delete top (1) from CATEGORIA where IdCategoria = @IdCategoria
		SET @Resultado = 1
	end 
	else
		set @Mensaje = 'La categoria se encuentra relacionada a un producto'
	end

	--METODOS_MARCA

	create proc sp_RegistrarMarca(
@Descripcion varchar(100),
@Activo bit,
@Mensaje varchar(500) output,
@Resultado int output
)
as
begin
	SET @Resultado = 0
	IF NOT EXISTS (SELECT * FROM MARCA where Descripcion = @Descripcion)
	begin
		insert into MARCA(Descripcion, Activo) values
		(@Descripcion,@Activo)
		set @Resultado = SCOPE_IDENTITY()
	end
	else
		set @Mensaje = 'La marca ya existe'
end
 


create proc sp_EditarMarca(
@IdMarca int,
@Descripcion varchar (100),
@Activo bit,
@Mensaje varchar (500) output,
@Resultado bit output
)
as
begin
	SET @Resultado = 0
	IF NOT EXISTS (SELECT * FROM MARCA WHERE Descripcion = @Descripcion and IdMarca != @IdMarca)
	begin
			update top (1) MARCA set
			Descripcion = @Descripcion,
			Activo = @Activo
			where IdMarca = @IdMarca
			SET @Resultado = 1
		end
		else
		set @Mensaje = 'La Marca ya existe'
end
 


	create proc sp_EliminarMarca(
	@IdMarca int,
	@Mensaje varchar(500) output,
	@Resultado bit output
	)
	as
	begin
		SET @Resultado = 0
		IF NOT EXISTS (select * from PRODUCTO p
		inner join MARCA m on m.IdMarca = p.IdMarca
		where p.IdMarca = @IdMarca)
		begin
			delete top (1) from MARCA where IdMarca = @IdMarca
			SET @Resultado = 1
		end
		else
			set @Mensaje = 'La marca se encuentra relacionada a un producto '
		end


--METODOS_PRODUCTOS

create proc sp_RegistrarProducto(
@Nombre varchar (100),
@Descripcion varchar (100),
@IdMarca varchar (100),
@IdCategoria varchar (100),
@Precio decimal (10,2),
@Stock int,
@Activo bit,
@Mensaje varchar (500) output,
@Resultado int output
)
as
begin
	SET @Resultado = 0
	IF NOT EXISTS (SELECT * FROM PRODUCTO WHERE Nombre = @Nombre)
	begin
		insert into PRODUCTO (Nombre, Descripcion, IdMarca, IdCategoria, Precio, Stock, Activo) values
		(@Nombre,@Descripcion, @IdMarca, @IdCategoria, @Precio, @Stock, @Activo)

		SET @Resultado = scope_identity()
	end
	else
	set @Mensaje = 'El producto ya existe'
end


create proc sp_EditarProducto(
@IdProducto int,
@Nombre varchar (100),
@Descripcion varchar (100),
@IdMarca varchar (100),
@IdCategoria varchar (100),
@Precio decimal (10,2),
@Stock int,
@Activo bit,
@Mensaje varchar (500) output,
@Resultado bit output
)
as
begin
	SET @Resultado = 0
	IF NOT EXISTS (SELECT * FROM PRODUCTO WHERE Nombre = @Nombre and IdProducto != @IdProducto)
	begin
			update PRODUCTO set
			Nombre = @Nombre ,
			Descripcion = @Descripcion, 
			IdMarca = @IdMarca,
			IdCategoria = @IdCategoria,
			Precio = @Precio,
			Stock = @Stock,
			Activo = @Activo
			where IdProducto = @IdProducto
			SET @Resultado = 1
			end
		else
			set @Mensaje = 'El producto ya existe'
		end


create proc sp_EliminarProducto(
@IdProducto int,
@Mensaje varchar (500) output,
@Resultado bit output
)
as 
begin
	SET @Resultado = 0
	IF NOT EXISTS (select * from DETALLE_VENTA dv 
	inner join PRODUCTO p on p.IdProducto = dv.IdProducto
	where p.IdProducto = @IdProducto)
	begin
		delete top (1) from PRODUCTO where IdProducto = @IdProducto
SET @Resultado = 1
end 
else 
	set @Mensaje = 'El producto se encuentra relacionado a una venta'
end


--CREAR_REPORTE

create proc sp_ReporteDashboard
as
begin

select 

(select COUNT (*) from CLIENTE) [TotalCliente],
(select ISNULL(sum (cantidad),0) from DETALLE_VENTA) [TotalVenta],
(select COUNT (*) from PRODUCTO)[TotalProducto]

end 



create proc sp_ReporteVentas(
@fechainicio varchar (10),
@fechafin varchar (10),
@idtransaccion varchar (50)
)
as 
begin
	
 set dateformat dmy;

select CONVERT(char(10),v.FechaVenta,103)[FechaVenta], CONCAT(c.Nombres,' ',c.Apellidos)[Cliente],
p.Nombre[Producto], p.Precio,  dv.Cantidad, dv.Total, v.IdTransaccion
from DETALLE_VENTA dv
inner join PRODUCTO p on p.IdProducto = dv.IdProducto
inner join VENTA v on v.IdVenta = dv.IdVenta
inner join CLIENTE c on c.IdCliente = dv.IdVenta
where CONVERT (date, v.FechaVenta) between @fechainicio and @fechafin
and v.IdTransaccion = iif (@idtransaccion = '', v.IdTransaccion, @idtransaccion)

end

--METODOS_CLIENTES

create proc sp_RegistrarCliente(
@Nombres varchar (100),
@Apellidos varchar (100),
@Correo varchar (100),
@Clave varchar (100),
@Mensaje varchar (500) output,
@Resultado int output
)
as
begin
	SET @Resultado = 0
	IF NOT EXISTS (SELECT * FROM CLIENTE WHERE Correo = @Correo)
begin
insert into CLIENTE(Nombres, Apellidos, Correo, Clave, Reestablecer) values
(@Nombres, @Apellidos, @Correo,@Clave,0)
	
	SET @Resultado = scope_identity()
end
	else
  set @Mensaje = 'El correo del usuario ya existe'
end


