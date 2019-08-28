import UIKit

extension Note {

    static func parse(json: [String: Any]) -> Note? {
        guard let uid = json["uid"] as? String,
            let title = json["title"] as? String,
            let content = json["content"] as? String
            else {return nil}
        
        var color: UIColor = .white
        if json["color"] != nil {
            let rgba = json["color"] as! [String: Any]
            color = UIColor(red: rgba["red"] as! CGFloat, green: rgba["green"] as! CGFloat, blue: rgba["blue"] as! CGFloat, alpha: rgba["alpha"] as! CGFloat)
        }
        
        var importance: Importance = .normal
        if json["importance"] != nil {
            importance = Importance(rawValue: json["importance"] as! Int)!
        }
        
        var selfDestructionDate: Date?
        if json["selfDestructionDate"] != nil {
            selfDestructionDate = Date(timeIntervalSince1970: json["selfDestructionDate"] as! TimeInterval)
        }
        
        return Note(uid: uid, title: title, content: content, color: color, importance: importance, selfDestructionDate: selfDestructionDate)
    }

    var json: [String: Any] {
        var data = [String: Any]()
        data["uid"] = self.uid
        data["title"] = self.title
        data["content"] = self.content
        
        if self.color != .white {
            let co = self.color.cgColor.components
            var color = [String: Float]()
            color["red"] = Float(co![0])
            color["green"] = Float(co![1])
            color["blue"] = Float(co![2])
            color["alpha"] = Float(co![3])
            data["color"] = color
        }
        
        if self.importance != .normal {
            data["importance"] = self.importance.rawValue
        }
        
        if selfDestructionDate != nil {
			data["selfDestructionDate"] = self.selfDestructionDate?.timeIntervalSince1970
		}
        return data
    }
}
