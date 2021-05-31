/* Промазал с темой)
final class MulticastDelegate<T> {
  private let delegates: NSHashTable<AnyObject> = NSHashTable.weakObjects()
  
  func add(_ delegate: T) {
    delegates.add(delegate as AnyObject)
  }
  
  func remove(_ delegateToRemove: T) {
    for delegate in delegates.allObjects.reversed() where delegate === delegateToRemove as AnyObject {
        delegates.remove(delegate)
    }
  }
  
  func invoke(_ invocation: (T) -> Void) {
    for delegate in delegates.allObjects.reversed() {
      guard let delegate = delegate as? T else { return }
      invocation(delegate)
    }
  }
}

class InformationMulticastDelegate: ContactInformationViewModelDelegate {
  private let multicast = MulticastDelegate<ContactInformationViewModelDelegate>()
  
  init(_ delegates: [ContactInformationViewModelDelegate]) {
    delegates.forEach(multicast.add)
  }
  
  func contactInformationViewModel(viewModel: ContactInformationViewModel, didChangeTextField: String) {
    multicast.invoke { $0.contactInformationViewModel(viewModel: viewModel, didChangeTextField: didChangeTextField) }
  }
}
// RAY

public class MulticastDelegate<ProtocolType> {
  // MARK: - DelegateWrapper
  private class DelegateWrapper {
    weak var delegate: AnyObject?

    init(_ delegate: AnyObject) {
      self.delegate = delegate
    }
  }
  
  // MARK: - Instance Properties
  private var delegateWrappers: [DelegateWrapper]

  public var delegates: [ProtocolType] {
    delegateWrappers = delegateWrappers
      .filter { $0.delegate != nil }
    return delegateWrappers.map
      { $0.delegate! } as! [ProtocolType]
  }

  // MARK: - Object Lifecycle
  public init(delegates: [ProtocolType] = []) {
    delegateWrappers = delegates.map {
      DelegateWrapper($0 as AnyObject)
    }
  }
  
  // MARK: - Delegate Management
  public func addDelegate(_ delegate: ProtocolType) {
    let wrapper = DelegateWrapper(delegate as AnyObject)
    delegateWrappers.append(wrapper)
  }

  public func removeDelegate(_ delegate: ProtocolType) {
    guard let index = delegateWrappers.firstIndex(where: {
      $0.delegate === (delegate as AnyObject)
    }) else {
      return
    }
    delegateWrappers.remove(at: index)
  }
  
  public func invokeDelegates(_ closure: (ProtocolType) -> ()) {
    delegates.forEach { closure($0) }
  }
}
 /**/*/
