//
//  HomeView.swift
//  Pomodoro
//
//  Created by Abegail Santos on 12/10/24.
//

import UIKit

class HomeView: UIView {

    var titleLabel: UILabel!
    var startButton: UIButton!
    var clockPic: UIImageView!
    var timerLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setupTitleLabel()
        setupClockPic()
        setupStartButton()
        setupTimerLabel()
        initConstraints()
    }
    
    func setupTitleLabel() {
        titleLabel = UILabel()
        titleLabel.text = "Pomodoro Timer"
        titleLabel.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        titleLabel.textColor = .systemBlue
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(titleLabel)
    }
    
    func setupClockPic() {
        clockPic = UIImageView()
        clockPic.image = UIImage(systemName: "clock")
        clockPic.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(clockPic)
    }
    
    func setupStartButton(){
        startButton = UIButton(type: .system)
        startButton.setTitle("Start Pomodoro", for: .normal)
        startButton.layer.borderWidth = 1
        startButton.layer.borderColor = UIColor.darkRed.cgColor
        startButton.layer.cornerRadius = 5
        startButton.layer.backgroundColor = UIColor.white.cgColor
        startButton.translatesAutoresizingMaskIntoConstraints = false
        startButton.setTitleColor(.darkRed, for: .normal)
        self.addSubview(startButton)
    }
    
    func setupTimerLabel() {
        timerLabel = UILabel()
        timerLabel.text = formatTime(25 * 60) // initial 25 minutes
        timerLabel.font = UIFont.systemFont(ofSize: 48, weight: .bold)
        timerLabel.textColor = .darkRed
        timerLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(timerLabel)
    }
    
    func initConstraints() {
        NSLayoutConstraint.activate([
            // Constraints for titleLabel
            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 100),
            
            // Constraints for clockPic
            clockPic.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            clockPic.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            clockPic.widthAnchor.constraint(equalToConstant: 100),
            clockPic.heightAnchor.constraint(equalToConstant: 100),
            
            // Constraints for timerLabel
            timerLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            timerLabel.topAnchor.constraint(equalTo: clockPic.bottomAnchor, constant: 20),
            
            // Constraints for startButton
            startButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            startButton.topAnchor.constraint(equalTo: timerLabel.bottomAnchor, constant: 50),
            startButton.widthAnchor.constraint(equalToConstant: 200),
            startButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func formatTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let seconds = seconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// Extend UIColor to include a dark red color
extension UIColor {
    static var darkRed: UIColor {
        return UIColor(red: 139/255, green: 0, blue: 0, alpha: 1)
    }
}
