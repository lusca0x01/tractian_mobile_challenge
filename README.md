
  

# Tractian Mobile Challenge

  

  

This project refers to a mobile challenge created by the Tractian company. The link for the [challenge](https://github.com/tractian/challenges/tree/main/mobile).

  

  

## The Idea

  

The idea is to **Build an Tree View Application that shows companies Assets**  _(The tree is basically composed with components, assets and locations)_.

  

  

## Dependencies

  

- To communicate with the API, I used the [http](https://pub.dev/packages/http) package.

- To render the SVG icons, I used the [flutter_svg](https://pub.dev/packages/flutter_svg) package.

- To state managing, providing and to separate the Business Logic and the UI, I used the [flutter_bloc](https://pub.dev/packages/flutter_bloc) package.

- To do object comparison, I used the [equatable](https://pub.dev/packages/equatable) package.

- To handle network connection and disconnection, I used the [connectivity_plus](https://pub.dev/packages/connectivity_plus) package.

- To handle with specific asynchronous operations, I used the [async](https://pub.dev/packages/async) package.

  

  

## The project

  

The layered architecture used in the project, follows the VGV (Very Good Ventures) [guide](https://verygood.ventures/blog/very-good-flutter-architecture).

  

The application has 3 core features, they are:

  

  

---

### API Service:

The **ApiService** is responsible for the communication with the server. It's a interface between the **BLoC's** and the server.

  

The **ApiService** contains a caching strategy. It relies on a memoization technique with a provided duration time _(5 seconds)_.

  

### Connection Checker

The **ConnectionChecker** is responsible for handling the actual network status _(offline and online)_ of the device.

  

It uses the lookup function provided in the dart:io library to verify if the application could reach the API URL. Based on that, the application knows if it's offline or online.

  

  

### Tree:

The **Tree** is responsible for generating and representing the requested **AssetsTree** for the challenge.

  

The **Tree** is composed of a list of **TreeNode** objects, each responsible for representing a node that corresponds to locations, assets, and components. The **TreeNode** class also maintains references to its children and parent.

  

The **Tree** generates its data based on a list of models provided by the API, which are correctly parsed.

  

Additionally, it can filter nodes based on their value (their name) and filter them by critical sensor components or energy sensor components.

  

For an UI perfomance needing (expanded nodes state), the **TreeNode** class has a variable that stores how many children are visible.

  

  

---

The application also has 2 main features, they are:

  

  

---

### Home:

The home feature contains the **View**, **Page**, **Model** and **BLoC** responsible for create and manage the **Home Page** flow.

  

The **HomeView** uses the list of companies provided by the API to generate a `ListView` of `Card`'s. Each card represents a specific company, displaying its name and icon, and when tapped, it redirects the user to that company's assets page.

  

The view handles three states: When the data is being fetched from the API, a centered `CircularProgressIndicator` is displayed to indicate loading. If the companies list is empty and the app is not loading, a message with a no-wifi icon and the text "Sem Internet" is shown, indicating that no data was retrieved due to a lack of internet connection. Once the data is successfully loaded, the `ListView` is populated with company cards, allowing users to tap and navigate to each company's specific assets page.

  

The **HomePage** is responsible for setting up the necessary dependencies for the **HomeBloc** using the **BlocProvider** and triggers the initial data fetch event when the page is loaded.

  

The **CompanyModel** is responsible for parsing the data getted from the API server on the **/companies** route.

  

The **HomeBloc** class is responsible for managing the state and events related to the home feature, specifically the fetching and updating of the list of companies. It utilizes the **BLoC** pattern to handle business logic, connectivity checks, and API calls, providing a clean separation between the user interface and data handling.

  

### Assets:

The assets feature contains the **View**, **Page**, **Model** and **BLoC** responsible for create and manage the **Assets Page** flow.

  

The **AssetsView** is responsible for displaying a list of assets, allowing users to search and filter through the available assets using the **AssetsBloc** for state management. The view is composed by a `SearchBar` that enables users to filter assets, locations or components by entering search terms (the name of them), utilizing a `TextEditingController` and a `RestartableTimer` to debounce input; this triggers a `SearchFilterEvent` after 500 milliseconds of inactivity. Additionally, it includes two **CustomToggleButtons** (a custom `ToggleButtons`) for filtering assets: one for energy sensors and another for critical ones, dispatching respective events when pressed. The central component of the view is the **TreeView**, which presents the hierarchical structure of assets based on the data fetched from the API; if the tree has no nodes, an error message ("Erro ao buscar dados da árvore") is displayed. When assets are being loaded, a `CircularProgressIndicator` appears.

  

The **TreeView** receives a **Tree** object as a parameter, which contains the root nodes of the asset hierarchy. The widget employs a `ListView.builder` to efficiently create and display each tree node using the **TreeNodeWidget**. Each node is initialized with an expansion state determined by the filters, and the **bigTree** parameter is set to true if the tree contains more than 100 nodes, allowing for optimized rendering.

  

The **TreeNodeWidget** is responsible for representing a node in the assets tree. It accepts a **TreeNode** object, which contains the node's data, along with two boolean properties: **initiallyExpanded** and **bigTree**. The widget utilizes an `ExpansionTile` to create an expandable view, allowing users to reveal or hide child nodes. If the node is categorized as an energy or critical node, it visually highlights this distinction with specific icons or styling. The widget manages its expansion state based on the **initiallyExpanded** property and retains this state if the node is not a leaf.

A pagination strategy is implemented for large trees. If a node contains children, the widget displays them according to the **bigTree** and **initiallyExpanded** parameters. If the tree (excluding leaves) has more than 100 nodes, it is classified as a **bigTree**. To optimize performance, the widget limits the number of initially visible children in the expanded state and provides a "Load more" option to reveal additional nodes in increments of ten.

The **HomePage** is responsible for setting up the necessary dependencies for the **HomeBloc** using the **BlocProvider** and triggers the initial data fetch event when the page is loaded.

  

The **LocationModel** is responsible for parsing the data getted from the API server on the **/locations** route.

The **AssetModel** is responsible for parsing the data getted from the API server on the **/assets** route.

The **ComponentModel** is responsible for parsing the data getted from the API server on the **/assets** route.

  

The **AssetsBloc** class is responsible for managing the state and events related to the assets feature, specifically the fetching and updating of the lists of locations, assets, and components. It handles the creation of the asset tree and applies filters to this tree. Utilizing the **BLoC** (Business Logic Component) pattern, this class encapsulates business logic, performs connectivity checks, and makes API calls, providing a clean separation between the user interface and data handling.