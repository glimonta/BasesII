drop table empleado cascade;
drop table empleado_nuevo cascade;
drop table cuenta_twitter cascade;
drop table departamento cascade;
drop table contrato cascade;
drop table descripción cascade;
drop table temp_json cascade;
drop type genero_t cascade;
drop type empleado_t cascade;
\unset jsonAna
\unset jsonHancel

create type genero_t as enum ('M', 'F');
create type empleado_t as enum ('R', 'G');

create table empleado (
  ci integer primary key,
  fecha_nacimiento date not null,
  nombre text not null,
  genero genero_t not null
);

create table cuenta_twitter (
  ci_empleado integer not null references empleado(ci),
  usuario text primary key
);

create table departamento (
  num_departamento integer primary key,
  nombre_departamento text not null unique
);

create table contrato (
  ci_empleado integer not null references empleado(ci),
  num_departamento integer not null references departamento(num_departamento),
  fecha_inicio date not null,
  fecha_fin date,
  salario money not null check (salario >= 0 :: money),
  tipo empleado_t not null,
  primary key(ci_empleado, num_departamento, fecha_inicio)
);

create table temp_json(
  datos json
);

create table descripción(
  usuario text not null references cuenta_twitter(usuario),
  descripción json
);

insert into departamento values (800, 'Departamento de computación');

insert into empleado values (19123456, '04-04-1989', 'Ana Alvarado', 'F');
insert into empleado values (18999123, '10-05-1989', 'Hancel Gonzalez', 'M');

insert into contrato values (19123456, 800, '01-09-2013', null, 25000, 'G');
insert into contrato values (18999123, 800, '01-01-2014', null, 15000, 'R');

--Este comando se corre desde psql de la siguiente forma:
--\copy cuenta_twitter from 'encuesta.csv' delimiter ',' csv;
\copy cuenta_twitter from 'encuesta.csv' delimiter ',' csv;

\set jsonAna `cat ana-desc.json`
\set jsonHancel `cat hancel-desc.json`

insert into descripción values (:'jsonAna'::json->>'screen_name', :'jsonAna');
insert into descripción values (:'jsonHancel'::json->>'screen_name', :'jsonHancel');

select d.descripción->>'followers_count' as número_followers
from descripción d
where d.usuario = 'leroygordo';

select d.descripción->'profile_location'->>'id' as id
from descripción d
where d.usuario = 'citricn';


--Pregunta 6
--descomentar para alterar las tablas (respuesta pregunta 6)
--alter table empleado
--add usuario text unique;
--
--update empleado
--set usuario = cuenta_twitter.usuario
--from cuenta_twitter
--where cuenta_twitter.ci_empleado = empleado.ci;
