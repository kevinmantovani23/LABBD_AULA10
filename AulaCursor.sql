CREATE DATABASE aulaseteout
USE aulaseteout

CREATE TABLE curso(
	codigo		INT,
	nome		VARCHAR(200),
	duracao		INT,
	PRIMARY KEY(codigo)
)

CREATE TABLE disciplinas(
	codigo		VARCHAR(6),
	nome		VARCHAR(200),
	carga_horaria INT,
	PRIMARY KEY(codigo)
)

CREATE TABLE disciplina_curso(
	codigo_disciplina	VARCHAR(6),
	codigo_curso		INT,
	FOREIGN KEY (codigo_disciplina) REFERENCES disciplinas(codigo),
	FOREIGN KEY (codigo_curso) REFERENCES curso(codigo),
	PRIMARY KEY (codigo_disciplina, codigo_curso)
)

CREATE ALTER FUNCTION fn_infocurso(@codCurso INT)
RETURNS @tabela TABLE (
codigo_disciplina	VARCHAR(6),
nome_disciplina		VARCHAR(200),
carga_horaria_disciplina	INT,
nome_curso VARCHAR(200)
)
AS
BEGIN
	DECLARE @codigodisc VARCHAR(6)
	DECLARE @nomedisc VARCHAR(200)
	DECLARE @cargaHora INT
	DECLARE @curso VARCHAR(200)
	DECLARE cCursoDisc CURSOR FOR SELECT disc.codigo, disc.nome,
										disc.carga_horaria, cur.nome
										FROM disciplinas disc, curso cur, disciplina_curso dcur WHERE
										cur.codigo = @codCurso AND
										dcur.codigo_curso = @codCurso AND
										disc.codigo = dcur.codigo_disciplina
	OPEN cCursoDisc
	FETCH NEXT FROM cCursoDisc INTO @codigodisc, @nomedisc, @cargaHora, @curso
	WHILE @@FETCH_STATUS = 0
	BEGIN
		
		INSERT INTO @tabela VALUES (@codigodisc, @nomedisc, @cargaHora, @curso)
		FETCH NEXT FROM cCursoDisc INTO @codigodisc, @nomedisc, @cargaHora, @curso
	END
	CLOSE cCursoDisc
	DEALLOCATE cCursoDisc
	RETURN
END

select * from fn_infocurso(48)