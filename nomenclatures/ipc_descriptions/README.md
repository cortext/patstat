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

## Setting up the virtual machine

[NICTA](http://www.data61.csiro.au/) developped in 2013 a set of API to query the patent classifications (IPC, CPC, USPC). This API is available [here](http://pat-clas.t3as.org/) and the code on [github](https://github.com/NICTA/t3as-pat-clas). Unfortunately, this implementation has unmet java dependencies and is based on IPC / CPC / USPC 2013 data, which is partly not available anymore on internet and not up to date.

[Cambialens](https://github.com/cambialens) forked the project and updated it to make it work with 2016 data. It is the repository we will use here to build our own server to set the API (it's much faster than using a remote API).

### Virtualization software

You can use any virtualization software. Its installation on the host machine is beyond the scope of this tutorial. In our case, we used [VirtualBox](https://www.virtualbox.org/).

### Guest server

We used [Ubuntu Server 16.04](https://www.ubuntu.com). You can mostly use any linux distribution, please adjust the package manager command if your OS is not using apt.

#### Installation

*Please refer to the manual of your virtualization software if you are not using VirtualBox.*

1. Download from [Ubuntu website](https://www.ubuntu.com) the installation image of Ubuntu Server 16.04 LTS.
2. Create a new virtual machine, set the name (whatever you want), the type as linux, the version as 'Ubuntu (64bits).'
3. Set the base memory as 1.5 Gb (VirtualBox recommends less, but you will run short of memory if you leave the default value), and a hard drive of 50 Gb (if you set a dynamic size, it will use only what it needs).
4. Start the VM and select the ISO file downloaded from Ubuntu server.
5. Follow the steps to install Ubuntu on the VM : leave all the default values, do not select any package to install (no Web Server, no Mail Server, etc...)
6. Restart at the end. You should be able to login with the credentials you defined during the installation.
7. (Optional) if you prefer to connect to your new virtual server with SSH, for example to be able to copy / paste, install ssh with `sudo apt install ssh` and forward one of your host ports to the port 22 of the guest server. In VirtualBox, you can forward ports in the network section of the VM settings.

#### Installation of the API

1. Update & Upgrade Ubuntu `sudo apt update && sudo apt dist-upgrade`
2. Install Git, Maven, OpenJDK `sudo apt install openjdk-8-jdk maven git`
3. Clone cambialens' repository `git clone https://github.com/cambialens/t3as-pat-clas.git`
4. Checkout the branch patcite `git checkout patcite`
5. You can now follow the instructions in the README file:
    1. Go to the data folder `cd ./t3as-pat-clas/data`.
		2. Run the download script `./download.sh`. It should fail downloading the file from USPTO (right now it is not available), and consequently stop the script. If it is the case, remove all the lines related to USPC (including the url that points to uspto.gov) from download.sh (you can edit it with `nano download.sh`) and run the script again.
		3. If you could not download files from USPTO, edit package.sh before running it, and remove the "uspc" reference (line 55). Then run `./package.sh`
    4. You should have now the indexes for CPC and IPC. The server will not run without indexes for USPC, but as the file is not available at uspto.gov right now, the trick is to copy one the other index (cpc or ipc) to uspc. You can do it with `cp cpcIndexExactSug uspcIndexExactSug && cp cpcIndexFuzzySug uspcIndexFuzzySug`. REMEMBER! The information of USPC will not be valid, so do not use this trick if you want to use the API for USPC.
    5. Compile the code `cd .. && maven`
    6. If you have no errors during the compilation, you can run the API with `cd t3as-pat-clas/pat-clas-service/ && mvn tomcat7:run`


## Accessing the API

You need to be able to reach the port 8080 to query the API. In VirtualBox, the easiest way is to go to VM network settings and forward one of the host port to the 8080 guest port.

The main idea of the _VM (virtual machine)_ is communicated directly from our LocalHost to the _t3as API_ project, in that way the load process could be much less than using directly the _t3as webpage_. For this we use an _OVA file (Open Virtualization Format)_, it is an open standard for packaging and distributing virtual appliance, that a file was created by Francois Perruchas, the file can be downloaded here: (The OVA size is 2,2gb)

[Download PatentApi.ova](https://cloud.esiee.fr/index.php/s/ZhRXSFum4DrFSu1/download)


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

Inside the project you can find a script wrote in python in which is possible to communicate with the local API that we previously build. When you execute it "03_02_abstract_from_ipc.py", what it does is read from the cvs file "03_01_abstract_from_ipc_input.csv" all the IPC codes and confront each one returning the necessary data to create the follow data structures: '01_position.cvs' '02_description.cvs', '03_ipc.cvs', '04_hierarchy.cvs'. 

To run the script is required you have installed python2

## Collecting the descriptions

One of the first goals of the script is collecting all the relate information about the international patent classification (IPC). For this we modeled two different structures, the first one called "ipc_position" store the principal information on the first three levels that IPC symbol belongs (Section, Class, Subclass). The ipc_position structure is composed of the following fields. 

 * ipc_position: the first three levels symbol. 
 * section: The title of the level, that means only the first part of the description (Uppercases).
 * class: The same as section.
 * subclass: The same as section.
 * full_subclass: The complete description of the subclass level (Uppercase and lower cases).
 
The next structure we called it "ipc_description" in which we concatenate and store the descriptions of the remaining levels. The structure contains.
 
  * ipc_code: IPC symbol
  * ipc_position: The position that the IPC symbol belongs to. 
  * ipc_desc: All the concatenate descriptions of the levels below to 1, 2 and 3 levels.
  * leve: The level that the IPC symbol belongs to.
  * version: The IPC classification version used to query the data.
 
## Rebuilding the IPC hierarchy

The other objective of this script is to organize all the hierarchy from the IPC in a relational structure. Thus we designed other two structures that are exported by the script like "03_ipc_list.output.csv" and "03_ipc_hierarchy.output.csv". Therefor we have one with all the list of the IPC symbols and their respective descriptions as shown in the next structure.
  
  * ipc_code: IPC symbol.
  * description: The direct, simple description of the international patent classification
  * ipc_version: The IPC classification version used to query the data.

And other one with each IPC symbol that are organized by an ancestor and by parent.
 
  * ipc_code: IPC symbol
  * ancestor: The preceding level of the ipc_code
  * parent: The symbol of the section level
  * ipc_version: The IPC classification version used to query the data.
 
## Example of results
