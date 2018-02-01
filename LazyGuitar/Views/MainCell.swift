import UIKit

class MainCell: UITableViewCell {

    @IBOutlet weak var cellBackgroundView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    
    var model: Model? {
        didSet {
            print("hello")
            guard let model = model else { return }
            nameLabel.text = model.noteName
            dateLabel.text = model.dateCreated
            countLabel.text = "\(model.chords.count)" + " Notes"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        updateUI()
    }
   
    func updateUI() {
        cellBackgroundView.layer.masksToBounds = false
        cellBackgroundView.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        cellBackgroundView.layer.shadowOffset = CGSize(width: 0.0, height: 1)
        cellBackgroundView.layer.shadowOpacity = 0.8
    }
}

extension MainCell {
    struct Model {
        var noteName: String
        var chords: [String]
        var dateCreated: String
    
        init(note: Note, index: Int){
            noteName = note.noteName
            chords = note.chords
            dateCreated = note.dateCreated.mediumStyleDate()!
        }
    }
}

extension MainCell: ReusableView { }
