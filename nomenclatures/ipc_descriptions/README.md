# Enriching Patstat: Descriptions for the International Patent Classification 

## Goals
Patents have fine grained information to describe the technologies that are combined by the applications. The IPC divides technology into eight sections with approximately 70 000 subdivisions. Each subdivision has a symbol consisting of Arabic numerals and letters of the Latin alphabet.
http://www.wipo.int/classifications/ipc/en/preface.html
A complete classification symbol comprises the combined symbols representing the 
section, class, subclass and main group or subgroup.

![ipc_classification](https://cloud.githubusercontent.com/assets/800631/24955826/56805dc0-1f85-11e7-86fa-574f48c6611e.jpg)
Guide to the IPC (2016) page 6 

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
