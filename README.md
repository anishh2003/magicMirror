# magicmirror

Note: 
The project has been tested on Android.

Architecture : 

I have implemented a feature based approach to this project.
By doing this , we can achieve separation between repository, business logic and screen.
By doing it this way , we can make changes easily to the respective sections without it directly affecting another.

The screen can only access the repository through the controller.The controller gets the data from the repository and applies the necessary business logic on it and gives  the data to the screen.

There are two features here : workout and WorkoutList.
They each have their own repository , controller and screen.


State management : 

I have used Riverpod as my preferred choice of state management. I have used this because it is scalable , immutable and is easy to follow. 
With proper architecture in place as above and using riverpod as in this project ,  we can achieve what  Bloc state management does in separation of concerns  , but with less boilerplate and easier to understand .

Navigation : 


Routemaster (similar to goRouter) has been used here as it is a versatile package which can be used for both web and mobile navigation. It keeps all navigation logic in one page. 

Testing : 


I did unit , widget testing for workout_screen.



Third party packages used : 

flutter_riverpod : for state management
routemaster : for keeping all routes organised in one file
collection: to use firstWhereOrNull , as Workout returned can be null and I can use this  
                   logic to add a new workout or update an existing one .
uuid :  To generate unique id for the workouts
integration_test : For integration tests




