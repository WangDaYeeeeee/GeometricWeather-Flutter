//@dart=2.12

enum ResourceStatus {
  SUCCESS, ERROR, LOADING
}

class Resource<T> {

  final T? data;
  final ResourceStatus status;

  Resource(this.data, this.status);

  static Resource<T> success<T>(T data) {
    return new Resource(data, ResourceStatus.SUCCESS);
  }

  static Resource<T> error<T>(T data) {
    return new Resource(data, ResourceStatus.ERROR);
  }

  static Resource<T> loading<T>(T data) {
    return new Resource(data, ResourceStatus.LOADING);
  }
}

abstract class ListEvent {}

class DataSetChanged implements ListEvent {
  const DataSetChanged();
}

class ItemInserted implements ListEvent {

  final int index;

  const ItemInserted(this.index);
}

class ItemChanged implements ListEvent {

  final int index;

  const ItemChanged(this.index);
}

class ItemRemoved implements ListEvent {

  final int index;

  const ItemRemoved(this.index);
}

class ItemMoved implements ListEvent {

  final int from;
  final int to;

  const ItemMoved(this.from, this.to);
}

class ListResource<T> {

  final List<T> dataList;
  final ListEvent event;
  
  ListResource(this.dataList, [this.event = const DataSetChanged()]);

  static ListResource<T> insertItem<T>(ListResource<T> current, T item, int index) {
    List<T> list = current.dataList;
    list.insert(index, item);
    return ListResource(list, new ItemInserted(index));
  }

  static ListResource<T> changeItem<T>(ListResource<T> current, T item, int index) {
    List<T> list = current.dataList;
    list[index] = item;
    return ListResource(list, new ItemChanged(index));
  }

  static ListResource<T> removeItem<T>(ListResource<T> current, int index) {
    List<T> list = current.dataList;
    list.remove(index);
    return ListResource(list, new ItemRemoved(index));
  }
}
