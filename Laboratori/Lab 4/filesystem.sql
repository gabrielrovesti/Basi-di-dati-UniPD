insert into Gruppo values
	('user', '2007-01-02'),
	('mail', '2006-01-01'),
	('admin', '2006-02-04'),
	('sys', '2006-12-25'),
	('none', '2007-01-01');
	
insert into Utente values
	('root',	NULL),
	('verdi',	'Gino Verdi'),
	('rossi',	'Anna Rossi'),
	('nobody',	NULL),
	('mail',	NULL);
	
insert into Appartenenza values
	('user',	'root'),
	('mail',	'root'),
	('admin',	'root'),
	('sys',		'root'),
	('user',	'verdi'),
	('mail',	'verdi'),
	('user',	'rossi'),
	('mail',	'rossi'),
	('mail',	'mail');

insert into Directory values
	(1,		'Radice',			'root',	'admin', NULL),
	(11,	'Var',			'root',	'admin',	1	),
	(111,	'Mail',			'mail',	'mail',	11	),
	(112,	'SubM',			'root',	'admin',	11	),
	(12,	'tmp',			'root',	'admin',	1	),
	(123,	'SubT',			'root',	'admin',	12	),
	(13,	'home',			'root',	'admin',	1	),
	(131,	'rossi',			'rossi',	'user',	13	),
	(132,	'verdi',			'verdi',	'user',	13	);

insert into File values
	(1111,	'rossi.mbx',		'rossi',	'mail',	111	),
	(1112,	'verdi.mbx',		'verdi',	'mail',	111	),
	(121,	'tmp0.txt',		'rossi',	'user',	12	),
	(122,	'tmp1.txt',		'verdi',	'user',	12	),
	(1311,	'slide.txt',		'rossi',	'user',	131	),
	(1312,	'progetto.pdf',	'rossi',	'user',	131	),
	(1321,	'eserc1.sql',		'rossi',	'user',	132 );