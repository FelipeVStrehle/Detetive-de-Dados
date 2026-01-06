extends Control

@onready var texto_label = $Panel/ScrollContainer/MarginContainer/RichTextLabel

# Texto da história do SQL
var historia_sql = """[center][font_size=48]📚 A História do SQL[/font_size][/center]

[font_size=32]🕰️ Anos 1970: O Nascimento[/font_size]

Em [b]1970[/b], Edgar F. Codd, um cientista da computação britânico trabalhando na IBM, publicou um artigo revolucionário: "A Relational Model of Data for Large Shared Data Banks". Este trabalho introduziu o conceito de [b]modelo relacional de dados[/b], que mudaria para sempre a forma como armazenamos e consultamos informações.

Inspirados pelo trabalho de Codd, dois pesquisadores da IBM, Donald D. Chamberlin e Raymond F. Boyce, desenvolveram em [b]1974[/b] a linguagem [b]SEQUEL[/b] (Structured English Query Language). O nome foi posteriormente alterado para [b]SQL[/b] (Structured Query Language) por questões de trademark.


[font_size=32]🚀 Anos 1980: A Popularização[/font_size]

Em [b]1979[/b], a Relational Software Inc. (que mais tarde se tornou Oracle Corporation) lançou o [b]Oracle V2[/b], o primeiro sistema de gerenciamento de banco de dados relacional comercial usando SQL.

A IBM lançou o [b]SQL/DS[/b] em 1981 e o [b]DB2[/b] em 1983, consolidando SQL como o padrão da indústria.

Em [b]1986[/b], o SQL foi oficialmente adotado como padrão pelo [b]ANSI[/b] (American National Standards Institute) e, em 1987, pela [b]ISO[/b] (International Organization for Standardization).


[font_size=32]💡 Por Que SQL?[/font_size]

SQL se tornou o padrão porque oferecia:

• [b]Simplicidade:[/b] Linguagem declarativa fácil de aprender
• [b]Portabilidade:[/b] Funciona em diferentes sistemas de banco de dados
• [b]Poder:[/b] Capaz de manipular milhões de registros eficientemente
• [b]Padronização:[/b] Aceito como padrão mundial


[font_size=32]🌍 SQL Hoje[/font_size]

Atualmente, SQL é usado por milhões de desenvolvedores ao redor do mundo. Está presente em:

• Aplicativos web e mobile
• Sistemas bancários e financeiros
• E-commerce e redes sociais
• Análise de dados e Business Intelligence
• Ciência de dados e Machine Learning

Sistemas populares que usam SQL incluem: [b]MySQL[/b], [b]PostgreSQL[/b], [b]Microsoft SQL Server[/b], [b]Oracle Database[/b], [b]SQLite[/b] e muitos outros.


[font_size=32]🎯 SQL no Futuro[/font_size]

Mesmo após mais de 40 anos, SQL continua relevante e em evolução. Novas versões do padrão SQL são lançadas regularmente, adicionando recursos para:

• Processamento de dados em tempo real
• Análise de dados não estruturados (JSON, XML)
• Machine Learning integrado
• Cloud computing e bancos de dados distribuídos


[center][font_size=28][b]SQL não é apenas uma linguagem - é a fundação da era da informação! 🚀[/b][/font_size][/center]

"""

func _ready():
	# Inicia a música do jogo
	Configuracoes.tocar_musica_jogo()

	texto_label.text = historia_sql
	# Habilita BBCode para formatação rica
	texto_label.bbcode_enabled = true

func _on_botao_voltar_pressed():
	# Retoma a música do menu ao voltar
	Configuracoes.tocar_musica_menu()
	# Volta para o menu principal
	GerenciadorCenas.trocar_cena("res://menu_principal.tscn")
