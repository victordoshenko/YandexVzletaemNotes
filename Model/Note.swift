import UIKit

struct Note {
    enum Importance : Int {
        case low    = 1
        case normal
        case high
    }
    let uid: String
    var title: String
    var content: String
    var color: UIColor
    let importance: Importance
    var selfDestructionDate: Date?
    let inDateTime: Date
    init(uid: String = UUID().uuidString, title: String, content: String, color: UIColor? = UIColor.white, importance: Importance, selfDestructionDate: Date? = nil) {
        self.uid = uid
        self.title = title
        self.content = content
        self.color = color ?? UIColor.white
        self.importance = importance
        self.selfDestructionDate = selfDestructionDate
        self.inDateTime = Date()
    }
}

class Notebook {
    var notes: [Note] = []
}

extension Note {
    static var allNotes: [Note] {
        return [
            Note(title: "Скажи-ка, дядя, ведь не даром", content: "Москва, спаленная пожаром,\nФранцузу отдана?\nВедь были ж схватки боевые,\nДа, говорят, еще какие!\nНедаром помнит вся Россия\nПро день Бородина!", color: UIColor.red, importance: .low),
            Note(title: "Да, были люди в наше время", content: "Не то, что нынешнее племя:\nБогатыри — не вы!\nПлохая им досталась доля:\nНемногие вернулись с поля…\nНе будь на то господня воля,\nНе отдали б Москвы!", color: UIColor.green, importance: .low),
            Note(title: "Мы долго молча отступали", content: "Досадно было, боя ждали,\nВорчали старики:\n«Что ж мы? на зимние квартиры?\nНе смеют, что ли, командиры\nЧужие изорвать мундиры\nО русские штыки?»", color: UIColor.blue, importance: .low),
            Note(title: "И вот нашли большое поле:", content: "Есть разгуляться где на воле!\nПостроили редут.\nУ наших ушки на макушке!\nЧуть утро осветило пушки\nИ леса синие верхушки —\nФранцузы тут как тут.", color: UIColor.yellow, importance: .low)
        ]
    }
}

extension String {
    
    func toDate(withFormat format: String = "yyyy-MM-dd HH:mm:ss")-> Date?{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: self)
        
        return date
        
    }
}
