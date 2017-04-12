# Enriching Patstat: building descriptions for the International Patent Classification 

## Goals
Patents have fine grained information to describe the technologies that are combined by the applications. The International Patent Classification (IPC) divides technology into eight sections with approximately 70 000 subdivisions. Each subdivision has a symbol consisting of Arabic numerals and letters of the Latin alphabet ([preface WIPO IPC](http://www.wipo.int/classifications/ipc/en/preface.html)).

A complete classification symbol comprises the combined symbols representing the section, class, subclass and main group or subgroup.

![ipc_classification](https://cloud.githubusercontent.com/assets/800631/24955826/56805dc0-1f85-11e7-86fa-574f48c6611e.jpg)
[Guide to the IPC (2016) page 6](http://www.wipo.int/export/sites/www/classifications/ipc/en/guide/guide_ipc.pdf)

After the Subclass 3rd level, the purely hierachical relations change: they are horizontal links between Groups, depending of the dots, from the main groups (e.g. 33/00) and the subgroups (e.g. 33/08), or directly between subgroups. IPC classes from main group to subgroup are separated with a maximun of 6 levels (and three more levels for section, class and subclass).

![ipc_classification_02](https://cloud.githubusercontent.com/assets/800631/24956247/20036e5c-1f87-11e7-999d-9e080f615835.jpg)
[Guide to the IPC (2016) page 7](http://www.wipo.int/export/sites/www/classifications/ipc/en/guide/guide_ipc.pdf)

In this example, 33/49 has a link to its parents 33/487 and 33/483, but 33/50 is a new subgroup class (i.e. not related to 33/483).

The aim of this work his to rebuild each sentence for a given IPC code from its parent classes, in a more human readable way.

## Selection of the IPC codes
If you are using a MySQL server, you can reproduce the scripts that are in [01_create_ipc_code_list.sql](01_create_ipc_code_list.sql), in order to produce the list of ipc code you want to look for.

| last_ipc_version | NbDistinctIPCcodes | NbAppln (with redundancies) | 
| --- | --- | --- |
| 2006-01-01 | 65379 | 154923559 |
| 2007-01-01 | 64 | 136029 |
| 2007-10-01 | 28 | 92883 |
| 2008-01-01 | 149 | 139044 |
| 2008-04-01 | 26 | 21552 |
| 2009-01-01 | 1402 | 7914864 |
| 2010-01-01 | 2092 | 21840972 |
| 2011-01-01 | 567 | 1463883 |
| 2012-01-01 | 610 | 1820008 |
| 2013-01-01 | 680 | 1285133 |
| 2014-01-01 | 336 | 619669 |

In the csv file [03_01_abstract_from_ipc_input.csv](03_01_abstract_from_ipc_input.csv) you will be able to find all the codes that are inside our patstat production version, with the attributs: 
* **last_ipc_version**: when a ipc code is used in different ipc version, last_ipc_version store the more recent version;
* **NbAppln**: raw volumes of all applications (with redundancies) for a given ipc code. For all patents, more than 71 000 distinct ipc codes were found.

## Installation and configuration of the virtual machine

The main idea of the _VM (virtual machine)_ is communicated directly from our LocalHost to the _t3as API_ project, in that way the load process could be much less than using directly the _t3as webpage_. For this we use an _OVA file (Open Virtualization Format)_, it is an open standard for packaging and distributing virtual appliance, that a file was created by Francois Perruchas, the file can be downloaded here: (The OVA was split in two and the size is 2,2gb)

[Download PatentApi.ova part 1](https://intercambio.upv.es/download.php?id=bbe8bb5741fd9052c9698aa2535187eb)

[Download PatentApi.ova part 2](https://intercambio.upv.es/download.php?id=47eb114c8ec5480b4db6ddfd81acf131)

To run the _VM_ we need a virtualization software, for us the software that fits our goals is _Virtualbox_ mainly because is a simple and an open source solution. To install and configure it you can refer to the follow urls: 

[Download VirtualBox](https://www.virtualbox.org/wiki/Downloads)

_Pages 34-43_

[VirtualBox UserManual](http://download.virtualbox.org/virtualbox/5.1.18/UserManual.pdf)

The next step is run our OVA file, for this you have to import the virtual machine into VirtualBox software, here is a graphical tutorial how you can do this:

[Tutorial: Importing and Exporting Virtual Machines](https://software.grok.lsu.edu/article.aspx?articleid=13838)

After our VM has been created and is running we proceed to login in with the next credentials:

```
User: user
Password: user 
```

Finally to launch the t3sa in our VM you have to type and execute the next command in the _terminal_:

```
cd t3as-pat-clas/pat-clas-service
mvn clean install tomcat7:run
```

To be able to access the API from your host PC, you have to follow one of the ports of the _host machine_ (The machine that host the VM) to the _port 8080_ of the VM. This can be done in the menu of Virtualbox “Machine>Settings>Network>Avanced>Port forwarding”. And there you can create a new rule putting as _“Host Port”_ the port that you want on your PC and _“Guest Port”_ 8080, and save the changes.

## Python script to interact with the VM
## Rebuilding the IPC hierarchy 
## Collecting the descriptions
## Example of results
