//
//  ContentView.swift
//  FolderPainter3000PRO
//
//  Created by Oleksii Voitenko on 05.05.2023.
//

import SwiftUI

struct ContentView: View {
    @State var directoryPath = ""
    
    var body: some View {
        List {
            if !directoryPath.isEmpty {
                Section("The chosen directory path") {
                    Text(directoryPath)
                }
            }
            Section {
                Button("Choose a folder") {
                    let panel = NSOpenPanel()
                    panel.title = "Choose a folder"
                    panel.allowsMultipleSelection = false
                    panel.canChooseDirectories = true
                    panel.canChooseFiles = false
                    if panel.runModal() == .OK, let url = panel.url {
                        directoryPath = url.path()
                    }
                }
            }
            if !directoryPath.isEmpty {
                Section("Do some magic 🪄") {
                    Button("Recolor it!") {
                        let folderIcon = NSWorkspace.shared.icon(for: .folder)
                        folderIcon.isTemplate = true
                        let redFolderIcon = folderIcon.image(with: .red)
                        setIcon(redFolderIcon, forDirectory: directoryPath)
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            if !directoryPath.isEmpty {
                Section {
                    Button("Reset to default icon") {
                        setIcon(nil, forDirectory: directoryPath)
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
        }
        .padding()
    }
    
    func setIcon(_ image: NSImage?, forDirectory withPath: String) {
        let result = NSWorkspace.shared.setIcon(image, forFile: withPath, options: NSWorkspace.IconCreationOptions.excludeQuickDrawElementsIconCreationOption)
        if result {
            NSWorkspace.shared.open(URL(filePath: directoryPath))
        } else {
            print("Ooops")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension NSImage {
    func image(with tintColor: NSColor) -> NSImage {
        if self.isTemplate == false {
            return self
        }
        
        let image = self.copy() as! NSImage
        image.lockFocus()
        
        tintColor.set()
        
        let imageRect = NSRect(origin: .zero, size: image.size)
        imageRect.fill(using: .sourceAtop)
        
        image.unlockFocus()
        image.isTemplate = false
        
        return image
    }
}
