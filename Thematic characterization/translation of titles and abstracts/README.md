# Enriching Patstat: Translating patent abstracts and titles

Patstat has very valuable textual information regarding each patent, such as its
name and abstract. More than 50 million abstracts can be found in the table
tls203_appln_abstr and more than 70 million titles can be found in the table
tls203_appln_title.

These tables also have a column that specifies the language of the title or
abstract, and, in a lot of cases, textual information about a certain patent can
be found only in one language, and, for most of those, it is the language from
the country where the patent application was first issued.

With this in mind, we have decided to translate abstracts and titles to English,
the most widely used language, and make these translations available in
patstat-ifris.

You can find out where the translated texts are and how we did it 
[here](docs/README.md).

Below is a summary of the number of patents for each language.

Titles:

| language code | language       | # of patents |
|---------------|----------------|--------------|
| en            | English        | 56309277     |
| de            | German         | 6157082      |
| fr            | French         | 2091501      |
| es            | Spanish        | 1357288      |
| zh            | Chinese        | 997339       |
| pt            | Portuguese     | 706798       |
| it            | Italian        | 647055       |
| da            | Danish         | 386337       |
| ja            | Japanese       | 300631       |
| ru            | Russian        | 296313       |
| fi            | Finnish        | 204977       |
| sv            | Swedish        | 201926       |
| no            | Norwegian      | 186800       |
| nl            | Dutch          | 185610       |
| tr            | Turkish        | 61960        |
| ko            | Korean         | 49986        |
| pl            | Polish         | 19508        |
| uk            | Ukrainian      | 17358        |
| id            | Indonesian     | 14635        |
| is            | Icelandic      | 7349         |
| et            | Estonian       | 6661         |
| el            | Greek          | 6396         |
| sh            | Serbo-Croatian | 4473         |
| ar            | Arabic         | 3190         |
| lv            | Latvian        | 1251         |
| lt            | Lithuanian     | 664          |
| ro            | Romanian       | 645          |
| cs            | Czech          | 594          |
| bg            | Breton         | 489          |
| bs            | Bosnian        | 217          |
| sr            | Serbian        | 64           |
| hu            | Hungarian      | 21           |
| sk            | Slovak         | 7            |
| hr            | Croatian       | 6            |
| sl            | slovene        | 1            |


Abstracts:

| language code | language       | # of patents |
|---------------|----------------|----------------|
| en            | English        | 42651474       |
| zh            | Chinese        | 996826         |
| es            | Spanish        | 842505         |
| de            | German         | 653340         |
| fr            | French         | 610125         |
| pt            | Portuguese     | 302761         |
| ko            | Korean         | 241055         |
| ja            | Japanese       | 227111         |
| ru            | Russian        | 141555         |
| no            | Norwegian      | 49890          |
| tr            | Turkish        | 47136          |
| it            | Italian        | 38754          |
| hu            | Hungarian      | 28316          |
| uk            | Ukrainian      | 24277          |
| pl            | Polish         | 18258          |
| ro            | Romanian       | 15573          |
| cs            | Czech          | 10116          |
| sh            | Serbo-Croatian | 9286           |
| el            | Greek          | 6393           |
| nl            | Dutch          | 5838           |
| da            | Danish         | 2074           |
| ar            | Arabic         | 1870           |
| bg            | Breton         | 1555           |
| sl            | Slovene        | 1376           |
| sr            | Serbian        | 815            |
| sk            | Slovak         | 610            |
| lv            | Latvian        | 178            |
| hr            | Croatian       | 166            |
| lt            | Lithuanian     | 70             |
| sv            | Swedish        | 2              |
| et            | Estonian       | 1              |
