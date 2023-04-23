//
//  EmojiTableViewController.swift
//  DC-LessonTableView-EmojiDictionary
//
//  Created by Антон Адамсон on 22.04.2023.
//

import UIKit

class EmojiTableViewController: UITableViewController {

    //массив эмодзи переехал в модель Эмодзи. теперь тут реализован вызов сохранения в файл после редактирования
    var emojis: [Emoji] = [] {
        didSet {
            Emoji.saveToFile(emojis: emojis)
        }
    }
             
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //изменение высоты ячеек чтобы влезал текст
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44.0
        
        //пытаемся загрузить даныне из файла
        if let savedEmojis = Emoji.loadFromFile() {
            emojis = savedEmojis
        } else {
            //если загрузка не удалась берем из базовый список из модели
            emojis = Emoji.sampleEmojis
        }
        
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

}
