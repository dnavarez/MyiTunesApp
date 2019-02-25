# MyiTunesApp
This app will use iTunes Search API to search for content on iTunes and display result in table view.


Desing Pattern: MVC and Composition

Using iOS MVC Pattern as it's recommended by apple but with Composition Design pattern applied to elliminate the well-known problem of Massive View-Controller.

Composition Design pattern helps to separate some procedures on view-controllers and making it composable so that it can be reusable. With this we are avoiding the massive growth of codes inside view-controller.

Also in regards to this but had not implemented it here as it's not common, I actually had a sample prototype structure for my project which I'm exploiting the use of "extension". Wherein you can separate class files for Methods, Events, Delegates, etc. In this way everything is separated and easily to debug/look on where to search for specific functions. Sample as seen below in folders and files segregation.


ViewControllers
	- SampleVC
    	- SampleVC.swift
    	- SVC.Methods.swift  	//SVC is the namespace for SampleVC
    	- SVC.Events.swift
    	- SVC.Delegates.swift



Database: Realm

In regards to saving the api json response, i'm using Realm platform as an alternative to Core Data