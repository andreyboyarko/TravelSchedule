

import SwiftUI

extension View {
    
    /// Выводит в консоль все доступные шрифты устройства.
    /// Полезно, если нужно посмотреть точные названия для .font(.custom).
    func printAllFonts() {
        for family in UIFont.familyNames.sorted() {
            print("🔤 Семейство: \(family)")
            
            let fontNames = UIFont.fontNames(forFamilyName: family).sorted()
            for fontName in fontNames {
                print("   📝 Шрифт: \(fontName)")
            }
            
            print("------------------------")
        }
    }
}
