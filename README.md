
The idea is to shape a component that serves to test with Javascript libraries downloaded from GitHub (for example) without unzipping.


A) Simple HTTP server for todoMVC

1) Put the exe  Todo2.exe in the same directory where is todomvc-master.zip
 (in example is in e: \ all)

2) execute
 \> todo2

3) Open Internet Explorer and access to
http: // localhost: 8082


B) HTTP server for angular-filemanager-master, (with partial file operations)
 1) put angular-filemanager-master.zip file in same directory than todo2

 2) execute
 \ > todo2 angular-filemanager-master

3) Open Internet Explorer and access to
http: // localhost: 8082



INSTALL todo2.exe
==================

Download from TodoRosetta page,

or . extract file from todo2bin.txt
1) rename todo2bin.txt in todo2bin.zip
2) then extract from todo2bin.zip todo2.exe



Often, when a demo is downloaded from github is difficult to prove directlyreasons.

There are several main 

We must decompress so that you can use from a browser.
	This entails choosing a path and unzip the library there is also often save the zip copy that was downloaded. (This creates many files and folders, which ultimately are already in a zip). If downloaded over different versions, over time, many redundant files are generated.

      2) often do not include all modules on which it depends, (for that bower is used, grunt, gult, ????). Typically they include commands to install the missing components, but that means that for every demo, you have to install all dependencies, generating more spending disk and duplicates with other projects or demos files.

     3) Another difficulty often occurs maybe you already have the libraries installed somewhere, but to use them, also have to change folder or have to modify the html itself, relative paths where the scripts.

The idea is to be able to use a project javascript github without having to decompress it, and * give different solutions to the dependence of external modules.

* Different solutions is because each project is different, and it is difficult to give a magic solution to all (for now), so we will work different threads solve certain problems and so gradually reduce the number of them that have no solution.

Information for programmers.

The TTodoServer component, must be independent enough to be able to relate to different web servers (not dependent on any particular) and their function is to act as service files within that server.

A web server is a program that serves HTTP requests, in many cases management represents a file with static content, type HTML, JS, CSS.
The file name is usually in the URL.  
/principal/index.html 
instructed to return the index.html file inside the main folder.

TTodoServer function is very simple. 
It passes the URL of a file, and returns the contents of that file.
The component will search the zip files downloaded the most likely filedecompressed.

This is the basic method of the component

(URL:
  url path (with params if possible)
  post: Posted in POST request content types
  result.The file related or
*).

   GetFilePost function ( const url, post: String): String; 

Example 

Todo.GetFilePost ('/principal/index.html', '');

return the index.html file in the folder / master

This is an example of use in Mormot:

TTestServer.Process function (ctxt: THttpServerRequest): cardinal;
var s: String;
begin
      s: = todo.GetFilePost (Ctxt.URL, Ctxt.InContent)
      Ctxt.OutContent: = s;
      Ctxt.OutContentType: = MimeType (ctxt. URL);
      if s = '' then
      begin
        result: = 404;
      end else
      begin
        result: = 200;
      end;
end;



If the requested file is in a zip, decompresses on the fly and returns it as if it were a file read directly.

If the required file is not within the zip, or not within the requested path, you can make searches within an order of preferences in other ways or external zip files, searching for files that could match the sought .

If you find several can selecionarse which of them will utiliar, or can Terner automatic take for example the current or older, bigger or smaller, take some text or particular function, etc ...

This feature it can be a problem on a project in which the path of the scripts is crucial and inseparable, so it is optional.

It will generate a log of requests made ​​and the direction of the return, or errors file if was found.


So far as we know that our engine will have to know unzip files. Here Zip will study different libraries.

We also know that it will be related to the web server.
	In this study different alternatives http server, and how to integrate with, (including whether it can Node.js)
	
Maybe you need to manipulate the result before You return, especially if dealing with objects or returned to an ajax call xml tables. So we also, different components and alternatives for working with XML and / JSON.

We will create an open source code libraries using open source as well, serving as an example to do the same with different libraries initiative and serve all over rossetta .


Version 0.01 alpha.
ToDoServer_mORMot. Minimum program, TToDoServer component usage.
	
	Use at least 3 Mormot features.library.

JSON  Reading and rendering.
Zip. (Instead of using another use next in the library)
THttpServer. Basic HTTP server. In the SynCrtSock.pas unit.




Angle-filemanager pluggin 

I liked the design of this project, and it's great to integrate it into a Web server. 
It is easy to implement server-side functions. So I implemented a seed in Delphi. Still not working all commands, but gives an idea of purpose.

I am sure that eventually we will use it for different purposes.





ToDo2 FAQS


Why the name?
ToDo_ToDoMVC, the idea is to make related todoMVC tools and all other libraries ToDo , executable from the command line.

todo2 for short name 
