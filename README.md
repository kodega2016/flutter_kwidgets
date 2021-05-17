##KFirebaseQueryWidget
It is a re-usable flutter widgets to query and display data from the firestore to
our flutter application. It is generic widgets so we have to pass type of the data
to be displayed.
- To use this widgets we have to first create a model class of the document of the collection and fromMap method to parse the data

![Builder](./ss/2.png?raw=true)

- We have to pass the collection path and also the builder to parse the data
And also we can pass firestore query to queryBuilder parameter as

![Widget](./ss/1.png?raw=true)