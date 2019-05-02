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
If you are using a MySQL server, you can reproduce the scripts that are in [01_create_ipc_code_list.sql](sql/01_create_ipc_code_list.sql), in order to produce the list of ipc code you want to look for.

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

**Note**: As we have applied this process to two versions of patstat database (2014 and 2017) with data from IPC 2016 and 2017 accordingly, you will find two folders with nearly identical content (patstat_2014 and patstat_2017).

In the csv files:
- [03_01_abstract_from_ipc_input.csv](patstat_2014/03_01_abstract_from_ipc_input.csv) for Patstat 2014
- [ipc_codes_input.csv](patstat_2017/ipc_codes_input.csv) for Patstat 2017

You will find all the codes that are inside our patstat production version, with the attributes: 
* **last_ipc_version**: when a ipc code is used in different ipc version, last_ipc_version store the more recent version.
* **NbAppln**: raw volumes of all applications (with redundancies) for a given ipc code. For all patents, more than 71 000 distinct ipc codes were found.

## Getting descriptions for IPC Codes

[NICTA](http://www.data61.csiro.au/) developped in 2013 a set of API to query the patent classifications (IPC, CPC, USPC). This API is available [here](http://pat-clas.t3as.org/) and the code on [github](https://github.com/NICTA/t3as-pat-clas). Unfortunately, this implementation has unmet java dependencies and is based on IPC / CPC / USPC 2013 data, which is partly not available anymore on internet and not up to date.

[Cambialens](https://github.com/cambialens) forked the project and have been updating it to make it work with data from recent years. This is what we will use to get descriptions for IPC codes.

### Setting up a virtual machine

We set up Cambialens' project in a local virtual machine (VM) in order to have our own server running the API, it's much faster than using a remote API.

### Virtualization software

To run the _VM_ we need a virtualization software, for us the software that fits our goals is _Virtualbox_ mainly because is a simple and an open source solution. 

You can use any virtualization software. Its installation on the host machine is beyond the scope of this tutorial. In our case, we used [VirtualBox](https://www.virtualbox.org/). To install and configure it you can refer to the following urls: 

[Download VirtualBox](https://www.virtualbox.org/wiki/Downloads)

_Pages 34-43_

[VirtualBox UserManual](http://download.virtualbox.org/virtualbox/5.1.18/UserManual.pdf)

### OVA Files

After having a virtualization software, the next step is to run the project in a virtual machine.

We have prepared OVA files (virtual machine files that you can import into your environment) with the API already set up and ready to run.

- Project with IPC 2016.01 database: [PatentApi.ova](https://cloud.esiee.fr/index.php/s/ZhRXSFum4DrFSu1/download) - Size: 2,2gb

Here is a graphical tutorial on how to import and export virtual machines so you can use this OVA file:

[Tutorial: Importing and Exporting Virtual Machines](https://software.grok.lsu.edu/article.aspx?articleid=13838)

These are the credentials for the VMs so you can login when you have the one you need up and running:

```
User: user
Password: user 
```

Finally, to launch t3sa (API) you have to type and execute the next command in the VM's _terminal_:

```
cd t3as-pat-clas/pat-clas-service
mvn tomcat7:run
```

To be able to access the API from your host PC, you have to forward one of the ports of the _host machine_ (The machine that host the VM) to the port used by the API in the _guest machine (VM)_, which is _port 8080_ for the 2016 version.

This can be done in the menu of Virtualbox “Machine>Settings>Network>Avanced>Port forwarding”. And there you can create a new rule putting as _“Host Port”_ the port that you want on your PC and _“Guest Port”_ 8080, and save the changes.

With this, you are ready to run our scripts to query the API.

### Guest server

You can skip this section if you do not want to create your own VM with the API from scratch.

We used [Ubuntu Server](https://www.ubuntu.com). You can mostly use any linux distribution, please adjust the package manager command if your OS is not using apt.

#### Installation

*Please refer to the manual of your virtualization software if you are not using VirtualBox.*

1. Download from [Ubuntu website](https://www.ubuntu.com) the installation image of Ubuntu Server, whatever the current LTS version.
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

For the 2016 version:

4. Checkout the branch patcite `git checkout patcite`
5. You can now follow the instructions in the README file:
    1. Go to the data folder `cd ./t3as-pat-clas/data`.
		1. Run the download script `./download.sh`. It should fail downloading the file from USPTO (right now it is not available), and consequently stop the script. If it is the case, remove all the lines related to USPC (including the url that points to uspto.gov) from download.sh (you can edit it with `nano download.sh`) and run the script again.
		2. If you could not download files from USPTO, edit package.sh before running it, and remove the "uspc" reference (line 55). Then run `./package.sh`
    1. You should have now the indexes for CPC and IPC. The server will not run without indexes for USPC, but as the file is not available at uspto.gov right now, the trick is to copy one the other index (cpc or ipc) to uspc. You can do it with `cp cpcIndexExactSug uspcIndexExactSug && cp cpcIndexFuzzySug uspcIndexFuzzySug`. REMEMBER! The information of USPC will not be valid, so do not use this trick if you want to use the API for USPC.
    2. Compile the code `cd .. && maven`
    3. If you have no errors during the compilation, you can run the API with `cd t3as-pat-clas/pat-clas-service/ && mvn tomcat7:run`

For the 2017 version:

4. You can now follow the instructions in the README file:
    1. Go to the data folder `cd ./t3as-pat-clas/data`.
		2. Run the download script `./download.sh`.
		3. Run `./package.sh`
    5. Compile the code from the project's root folder `cd .. && mvn`
    6. If you have no errors during the compilation, you can run the API with `cd t3as-pat-clas/pat-clas-service/ && mvn tomcat7:run`

## Python script to interact with the VM

There are Python scripts in both patstat_2014 and patstat_2017 that make use of the files generated from the database and the corresponding APIs running in virtual machines and produce the desired results.

For Patstat 2014:

**Python 2 required.**

In order to run the script: `python 03_02_abstract_from_ipc.py`. It takes some minutes to run. What it does is read from the cvs file "03_01_abstract_from_ipc_input.csv" all the IPC codes and confront each one returning the necessary data to create the follow data structures: '01_position.cvs' '02_description.cvs', '03_ipc.cvs', '04_hierarchy.cvs'.

For Patstat 2017:

**Python 3 required.**

We provided a Pipfile in case you use `pipenv`, if not, you will first have to install dependencies with:

`pip install -r requirements.txt`

And then you can run the script with:

`python abstract_from_ipc.py`

This script reads the input file `ipc_codes_input.csv`, queries the API with this information, and produces the structures described below in 4 output files under the  `results` subfolder.

## Collecting the descriptions

One of the first script's goal is collecting all the relate information about the international patent classification (IPC). For this we modeled two different structures, the first one called "ipc_position" store the principal information on the first three levels that IPC symbol belongs (Section, Class, Subclass). The ipc_position structure is composed of the following fields. 

 * ipc_position: the first three levels symbol. 
 * section: The title of the level, that means only the first part of the description (Uppercases).
 * class: The same as section.
 * subclass: The same as section.
 * full_subclass: The complete description of the subclass level (Uppercase and lower cases).
 
The next structure we called it "ipc_description" in which we concatenate and store the descriptions of the remaining levels. The structure contains.
 
  *  ipc_class_level: IPC symbol
  * ipc_position: The position that the IPC symbol belongs to. 
  * ipc_desc: All the concatenate descriptions of the levels below to 1, 2 and 3 levels.
  * leve: The level that the IPC symbol belongs to.
  * version: The IPC classification version used to query the data.
 
## Rebuilding the IPC hierarchy

The other objective of this script is to organize all the hierarchy from the IPC in a relational structure. Thus we designed other two structures that are exported by the script like "03_ipc_list.output.csv" and "03_ipc_hierarchy.output.csv". Therefor we have one with all the list of the IPC symbols and their respective descriptions as shown in the next structure.
  
  *  ipc_class_level: IPC symbol.
  * description: The direct, simple description of the international patent classification
  * ipc_version: The IPC classification version used to query the data.

And other one with each IPC symbol that are organized by an ancestor and by parent.
 
  *  ipc_class_level: IPC symbol
  * ancestor: The preceding level of the  ipc_class_level
  * parent: The symbol of the section level
  * ipc_version: The IPC classification version used to query the data.
 
## Example of results

As stated above, when the script finishes, as a result, we have four different data structures, as an example we took two formed structure (ipc_position and ipc_description) from the IPC symbols:

A01B3/66

A01G31/02

The first formed structure was created thinking in a way to organize all the first three levels from a different main group occurs. Thus the position code for the A01B3/66 ipc symbol is A01B and for A01G31/02 is A01G, these represent the positions for many different IPC symbols. Then, with that in mind, we have the next table: 

| ipc_positon | section | class | subclass | full_subclass | ipc_version | 
| --- | --- | --- | --- | --- | --- |
| ..... | ..... | ..... | ..... | ..... | ..... | 
| A01B | Human Necessities | Agriculture Forestry Animal Husbandry Hunting.... | Soil Working In Agriculture Or Forestry Parts... | SOIL WORKING IN AGRICULTURE OR FORESTRY PARTS, DETAILS, OR ACCESSORIES OF AGRICULTURAL MACHINES OR IMPLEMENTS, IN GENERAL making or covering furrows or holes for sowing, planting...  | 2016.01 | 
| A01G | Human Necessities | Agriculture Forestry Animal Husbandry Hunting... | Horticulture Cultivation Of Vegetables Flowers Rice... | HORTICULTURE CULTIVATION OF VEGETABLES, FLOWERS, RICE, FRUIT, VINES, HOPS, OR SEAWEED FORESTRY WATERING picking of fruits, vegetables, hops, or the like plant reproduction by.... | 2016.01  | 
| ..... | ..... | ..... | ..... | ..... | ..... | 

We build the second structure with the remaining data (main group and sub groups) and we concatenated and store it inside the column ipc_desc how is represented in the resulting table: 

|  ipc_class_level | ipc_position | ipc_desc | level | ipc_version | 
| --- | --- | --- | --- | --- |
| ..... | ..... | ..... | ..... | ..... | 
| A01B   3/66 | A01B | Ploughs with fixed plough-shares. Cable ploughs. Indicating or signalling devices for cable plough systems with... | 5 | 2016.01 | 
| A01G  31/02 | A01G | Hydroponics. Cultivation without soil takes precedence. Special apparatus therefor apparatus for cultivation in.. | 4 | 2016.01  | 
| ..... | ..... | ..... | ..... | ..... | 

It should be noted that the text were cleaned with the idea of being able to be used with "Natural language processing". In some cases such as chemistry formulas or vitamins names the "cleaning text method" puts a dot before these.
