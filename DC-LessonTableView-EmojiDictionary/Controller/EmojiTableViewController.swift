//
//  EmojiTableViewController.swift
//  DC-LessonTableView-EmojiDictionary
//
//  Created by Антон Адамсон on 22.04.2023.
//

import UIKit

class EmojiTableViewController: UITableViewController {

    var emojis: [Emoji] = [
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
             
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //изменение высоты ячеек чтобы влезал текст
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44.0
        
    }

    //автообновление таблицы при возврате к самому вью с представлением
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    //действие по нажатию кнопки edit в таббаре
    @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {
        let tableViewEditingMode = tableView.isEditing
        
        tableView.setEditing(!tableViewEditingMode, animated: true)
    }
    
    //действие при осуществлении перехода при нажатии на кнопку добавления или выборе ячейки
    @IBSegueAction func addEditEmoji(_ coder: NSCoder, sender: Any?) -> AddEditTableViewController? {
        if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) {
            //Редактирование эмоджи
            let emojiToEdit = emojis[indexPath.row]
            return AddEditTableViewController(coder: coder, emoji: emojiToEdit)
        } else {
            //Adding emoji
            return AddEditTableViewController(coder: coder, emoji: nil)
        }
    }
    
    //функция для перехода с экрана редактирования/добавления и получение данных из AddEditTableViewController
    @IBAction func unwindToEmojiTableViewController(segue: UIStoryboardSegue) {
        guard segue.identifier == "saveUnwind", let sourceViewController = segue.source as? AddEditTableViewController,
                let emoji = sourceViewController.emoji else { return }
        
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            emojis[selectedIndexPath.row] = emoji
            tableView.reloadRows(at: [selectedIndexPath], with: .none)
        } else {
            let newIndexPath = IndexPath(row: emojis.count, section: 0)
            emojis.append(emoji)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        }
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // Количество секций - 1
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // возвращаем столько строк, сколько элементво в массиве emojis
        return emojis.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //конфигурация ячейки
        //определим cell как переиспользуемую ячейку в tableView
        //для версии 1.1 изменим конфигурирование ячейки
        let cell = tableView.dequeueReusableCell(withIdentifier: "EmojiCell", for: indexPath) as! EmojiTableViewCell
        //определим emoji как объект из массива emojis по его индексу с помощью indexPath и метода row(строка)
        let emoji = emojis[indexPath.row]
        //для версии 1.1 поменяем определение контента  теперь он определяется с помощью функции из файла EmojiTableViewCell
        cell.update(with: emoji)
        cell.showsReorderControl = true
        
        return cell
    }
    
    /*
     на удаление
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //в этом методе выполняется действие по нажатию на ячейку
        let emoji = emojis[indexPath.row]
        print("\(emoji.symbol) \(indexPath)")
    }
     */
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */
    
    //действия для активации возможности удаления ячейки
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    

    // Override to support editing the table view. Modified
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            emojis.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }    
    }



    // метод для перемещения ячейки
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let movedEmoji = emojis.remove(at: fromIndexPath.row)
        emojis.insert(movedEmoji, at: to.row)
    }


    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
