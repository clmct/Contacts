import UIKit

final class PickerDataSource<Model>: NSObject, UIPickerViewDataSource {
  private var models: [Model]
  
  init(models: [Model]) {
    self.models = models
  }
  
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    models.count
  }
}
