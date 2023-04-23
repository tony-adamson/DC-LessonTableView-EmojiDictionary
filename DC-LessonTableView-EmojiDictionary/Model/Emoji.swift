//
//  Emoji.swift
//  DC-LessonTableView-EmojiDictionary
//
//  Created by Антон Адамсон on 22.04.2023.
//

import Foundation

struct Emoji :Codable {
    var symbol: String
    var name: String
    var description: String
    var usage: String
    
    //статическое свойство archiveURL, которое возвращает путь к файлу Documents/emojis.plist.
    static var archiveURL: URL {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let archiveURL = documentsURL.appendingPathComponent("emojis").appendingPathExtension("plist")
        
        return archiveURL
    }
    
    //массив из контроллера. теперь он здесь в качестве свойства с возвращаемым значением
    static var sampleEmojis: [Emoji] {
        return [
            Emoji(symbol: "😀", name: "Grinning Face",
                  description: "A typical smiley face.", usage: "happiness"),
            Emoji(symbol: "😕", name: "Confused Face",
                  description: "A confused, puzzled face.", usage: "unsure what to think; displeasure"),
            Emoji(symbol: "😍", name: "Heart Eyes",
                  description: "A smiley face with hearts for eyes.", usage: "love of something; attractive"),
            Emoji(symbol: "🧑‍💻", name: "Developer",
                  description: "A person working on a MacBook (probably using Xcode to write iOS apps in Swift).",
                  usage: "apps, software, programming"),
            Emoji(symbol: "🐢", name: "Turtle", description: "A cute turtle.", usage: "something slow"),
            Emoji(symbol: "🐘", name: "Elephant", description: "A gray elephant.", usage: "good memory"),
            Emoji(symbol: "🍝", name: "Spaghetti", description: "A plate of spaghetti.", usage: "spaghetti"),
            Emoji(symbol: "🎲", name: "Die", description: "A single die.", usage: "taking a risk, chance; game"),
            Emoji(symbol: "⛺️", name: "Tent", description: "A small tent.", usage: "camping"),
            Emoji(symbol: "📚", name: "Stack of Books", description: "Three colored books stacked on each other.",
                  usage: "homework, studying"),
            Emoji(symbol: "💔", name: "Broken Heart", description: "A red, broken heart.",
                  usage: "extreme sadness"),
            Emoji(symbol: "💤", name: "Snore", description: "Three blue \'z\'s.", usage: "tired, sleepiness"),
            Emoji(symbol: "🏁", name: "Checkered Flag",  description: "A black-and-white checkered flag.",
                  usage: "completion"),
            Emoji(symbol: "💩", name: "Shit", description: "Big mountain of shit", usage: "Very bad situation"),
            Emoji(symbol: "🤡", name: "Clown", description: "Man - who think development its easy",
                  usage: "only for holywars"),
            Emoji(symbol: "🧠", name: "Brain", description: "IQ 150", usage: "rarely"),
            Emoji(symbol: "🦾", name: "ChatGPT", description: "Thing thing is smarter then you",
                  usage: "never"),
            Emoji(symbol: "🐸", name: "pepe", description: "green frog from memes", usage: "regullary"),
            Emoji(symbol: "🍔", name: "BigMac", description: "Many calories, junk food", usage: "every day")
        ]
    }
    
    //функция для сохранения массива эмодзи
    static func saveToFile(emojis: [Emoji]) {
        let encoder = PropertyListEncoder()
        do {
            let encodedEmojis = try encoder.encode(emojis)
            try encodedEmojis.write(to: Emoji.archiveURL)
        } catch {
            print("Ошибка кодирования эмодзи \(error)")
        }
    }
    
    //функция для загрузки массива эмодзи
    static func loadFromFile() -> [Emoji]? {
        guard let emojiData = try? Data(contentsOf: Emoji.archiveURL) else {
            return nil
        }
        
        do {
            let decoder = PropertyListDecoder()
            let decodedEmojis = try decoder.decode([Emoji].self, from: emojiData)
            
            return decodedEmojis
        } catch {
            print("Ошибка декодирования эмодзи \(error)")
            return nil
        }
    }
}


