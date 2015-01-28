iTunesSearch, a simple app to view the search results returned from itunes.

Application structure:

Controller Classes:
1. SearchMainViewController
The main view controller of the app, responsible for talking to the model class
that initiates the search request, and then displays the returned search results
inside a UICollectionView.

The main view of the app consists from a basic text field, where the user can enter
his search keywords. When the user finishes entering search text and presses 'Search',
the search text is then passed to another class 'SearchDataParser'. 'SearchDataParser'
performs some operations on the text, sends an Asynchronous HTTP Request, and then
notifies the 'SearchMainViewController' of finishing. 'SearchMainViewController'
starts then to display the returned results, and when you tap on any cell, a detailed
view opens with more info about this specific cell. The view that holds the detailed
info is called 'SearchResultDetailsViewController'.

2. SearchResultDetailsViewController
The view controller that's used to hold the detaild info about a specific search result.
We pass the search result info the the detailed view controller from 'SearchMainViewController',
inside the 'prepareForSegue' method.

Model Classes:
1. SearchDataParser
It begins by checking if the input text contains any spaces, and removes them. It then begins
to create the full URL needed to begin the search Async operation, by appending the search
components with '+' delimiter between them. The search operation is done in background,
as I use AFNetworking library.

2. SearchResultsCollectionViewCell
A class inheriting from UICollectionViewCell, that loads the Nib view of the cell containing
the search results. Any UI related customizations are added inside the initWithFrame method,
like adding a border around the media image and adding a separator view between each cell
and the next cell.

The application is supported on both iPhone and iPad.