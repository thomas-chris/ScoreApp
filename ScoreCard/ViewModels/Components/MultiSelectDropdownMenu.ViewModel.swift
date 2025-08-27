
import SwiftUI

extension MultiSelectDropdownMenu {
    @Observable
    class ViewModel {
        
        let options: [T]
        var isExpanded = false
        var selectedOptions: Binding<Set<T>>
        
        init(options: [T], selectedOptions: Binding<Set<T>>) {
            self.options = options
            self._selectedOptions = selectedOptions
        }
        
        func didTap(_ option: T) {
            if selectedOptions.wrappedValue.contains(option) {
                selectedOptions.wrappedValue.remove(option)
            } else {
                selectedOptions.wrappedValue.insert(option)
            }
        }
    }
}
