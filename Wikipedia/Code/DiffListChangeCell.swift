
import UIKit

class DiffListChangeCell: UICollectionViewCell {
    static let reuseIdentifier = "DiffListChangeCell"
    
    @IBOutlet var textLeadingConstraint: NSLayoutConstraint!
    @IBOutlet var textTrailingConstraint: NSLayoutConstraint!
    @IBOutlet var textTopConstraint: NSLayoutConstraint!
    @IBOutlet var textBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet var innerLeadingConstraint: NSLayoutConstraint!
    @IBOutlet var innerTrailingConstraint: NSLayoutConstraint!
    @IBOutlet var innerBottomConstraint: NSLayoutConstraint!
    @IBOutlet var innerTopConstraint: NSLayoutConstraint!
    
    @IBOutlet var headingLeadingConstraint: NSLayoutConstraint!
    @IBOutlet var headingTopConstraint: NSLayoutConstraint!
    @IBOutlet var headingBottomConstraint: NSLayoutConstraint!
    @IBOutlet var headingTrailingConstraint: NSLayoutConstraint!
    
    @IBOutlet var headingContainerView: UIView!
    @IBOutlet var headingLabel: UILabel!
    @IBOutlet var textStackView: UIStackView!
    @IBOutlet var innerView: UIView!
    
    private(set) var viewModel: DiffListChangeViewModel?
    
    func update(_ viewModel: DiffListChangeViewModel) {
        
        textLeadingConstraint.constant = viewModel.textPadding.leading
        textTrailingConstraint.constant = viewModel.textPadding.trailing
        textTopConstraint.constant = viewModel.textPadding.top
        textBottomConstraint.constant = viewModel.textPadding.bottom
        
        innerLeadingConstraint.constant = viewModel.innerPadding.leading
        innerTrailingConstraint.constant = viewModel.innerPadding.trailing
        innerTopConstraint.constant = viewModel.innerPadding.top
        innerBottomConstraint.constant = viewModel.innerPadding.bottom
        
        headingLeadingConstraint.constant = viewModel.headingPadding.leading
        headingTrailingConstraint.constant = viewModel.headingPadding.trailing
        headingBottomConstraint.constant = viewModel.headingPadding.bottom
        headingTopConstraint.constant = viewModel.headingPadding.top

        if needsNewTextLabels(newViewModel: viewModel) {
            removeTextLabels(from: textStackView)
            addTextLabels(to: textStackView, newViewModel: viewModel)
        }
        
        updateTextLabels(in: textStackView, newViewModel: viewModel)
        
        //theming
        backgroundColor = viewModel.theme.colors.paperBackground
        contentView.backgroundColor = viewModel.theme.colors.paperBackground
        
        innerView.borderWidth = 1
        innerView.borderColor = viewModel.borderColor
        innerView.layer.cornerRadius = viewModel.innerViewClipsToBounds ? 7 : 0
        innerView.clipsToBounds = viewModel.innerViewClipsToBounds
        
        headingContainerView.backgroundColor = viewModel.borderColor
        headingLabel.attributedText = viewModel.headingAttributedString

        self.viewModel = viewModel
    }
}

private extension DiffListChangeCell {
    func removeTextLabels(from textStackView: UIStackView) {
        for subview in textStackView.arrangedSubviews {
            textStackView.removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }
    }
    
    func addTextLabels(to textStackView: UIStackView, newViewModel: DiffListChangeViewModel) {
        for _ in newViewModel.items {
            let label = UILabel()
            label.numberOfLines = 0
            label.lineBreakMode = .byWordWrapping
            textStackView.addArrangedSubview(label)
        }
    }
    
    func updateTextLabels(in textStackView: UIStackView, newViewModel: DiffListChangeViewModel) {
        for (index, subview) in textStackView.arrangedSubviews.enumerated() {
            if let label = subview as? UILabel,
                let item = newViewModel.items[safeIndex: index] {
                label.attributedText = item.textAttributedString
            }
        }
    }
    
    func needsNewTextLabels(newViewModel: DiffListChangeViewModel) -> Bool {
        guard let viewModel = viewModel else {
            return true
        }
        
        if viewModel.items != newViewModel.items {
            return true
        }
        
        return false
    }
}
