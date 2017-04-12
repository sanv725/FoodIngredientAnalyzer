# FoodIngredientAnalyzer

This is a prototype project to display what the implementation of food ingredient prediction using Clarifai's API could look like in the Cara app. A camera icon is added to the "Add food..." text field that allows user to take a picture of their food when they click on it. Once the user chooses that photo, it's sent over to Imgur to host the image temporarily and then the url link to the image is sent to Clarifai to predict the ingredients in the food based on their food model. Based on the predictions, only ingredients with scores above 70% are shown to the user, where upon they are allowed to select any ingredients that they think are valid. The selected ingredients are then added as tags in the same way it's already being done in the Cara app.

While not implemented in this prototype, it's possible to improve the food model used by Clarifai by sending over any new ingredients that the user adds that weren't in the prediction list as additional feedback using the Clarifai's API for that food. 

![](http://i.imgur.com/HD40QKA.gif?1)
