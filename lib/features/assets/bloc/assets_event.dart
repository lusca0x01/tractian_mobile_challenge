abstract class AssetsEvent {
  const AssetsEvent();
}

class FetchAssetsEvent extends AssetsEvent {
  const FetchAssetsEvent();
}

class EnergySensorFilterEvent extends AssetsEvent {
  const EnergySensorFilterEvent();
}

class CriticalFilterEvent extends AssetsEvent {
  const CriticalFilterEvent();
}

class SearchFilterEvent extends AssetsEvent {
  const SearchFilterEvent(this.searchText);

  final String searchText;
}
