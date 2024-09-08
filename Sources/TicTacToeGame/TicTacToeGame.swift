// The Swift Programming Language
// https://docs.swift.org/swift-book

import UIKit

public protocol TicTacToeViewDelegate: AnyObject {
    func gameDidEnd(withMessage message: String)
}

public class TicTacToeView: UIView {
    private let spacing: CGFloat = 8
    private let gridDimension = 3
    private var currentPlayer: Player = .x
    private var gameBoard: [[Player?]] = Array(repeating: Array(repeating: nil, count: 3), count: 3)
    private var squares: [[UIView]] = []
    
    private var squareSize: CGFloat
    private var cellColor: UIColor
    public weak var delegate: TicTacToeViewDelegate?

    public init(frame: CGRect, squareSize: CGFloat, cellColor: UIColor = .gray) {
        self.squareSize = squareSize
        self.cellColor = cellColor
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        self.squareSize = UIScreen.main.bounds.height / 8 // Значение по умолчанию
        self.cellColor = .gray
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        for row in 0..<gridDimension {
            var rowSquares: [UIView] = []
            for col in 0..<gridDimension {
                let square = UIView()
                square.backgroundColor = cellColor
                square.layer.cornerRadius = 8
                square.translatesAutoresizingMaskIntoConstraints = false
                addSubview(square)
                
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
                square.addGestureRecognizer(tapGesture)
                square.tag = row * gridDimension + col
                
                NSLayoutConstraint.activate([
                    square.widthAnchor.constraint(equalToConstant: squareSize),
                    square.heightAnchor.constraint(equalToConstant: squareSize),
                    square.leadingAnchor.constraint(equalTo: leadingAnchor, constant: CGFloat(col) * (squareSize + spacing)),
                    square.topAnchor.constraint(equalTo: topAnchor, constant: CGFloat(row) * (squareSize + spacing))
                ])
                
                rowSquares.append(square)
            }
            squares.append(rowSquares)
        }
    }
    
    @objc private func handleTap(_ sender: UITapGestureRecognizer) {
        guard let square = sender.view else { return }
        let row = square.tag / gridDimension
        let col = square.tag % gridDimension
        
        if gameBoard[row][col] != nil {
            return
        }
        
        gameBoard[row][col] = currentPlayer
        updateSquare(square, with: currentPlayer)
        
        if let winningCombination = checkWin(for: currentPlayer) {
            highlightWinningCombination(winningCombination)
            delegate?.gameDidEnd(withMessage: "\(currentPlayer.rawValue) выиграл!")
        } else if isBoardFull() {
            delegate?.gameDidEnd(withMessage: "Ничья!")
        } else {
            currentPlayer = (currentPlayer == .x) ? .o : .x
        }
    }
    
    private func updateSquare(_ square: UIView, with player: Player) {
        let label = UILabel()
        label.text = player.rawValue
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 36)
        label.translatesAutoresizingMaskIntoConstraints = false
        square.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: square.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: square.centerYAnchor)
        ])
    }
    
    private func checkWin(for player: Player) -> [(Int, Int)]? {
        for i in 0..<gridDimension {
            if gameBoard[i].allSatisfy({ $0 == player }) {
                return (0..<gridDimension).map { (i, $0) }
            }
            if (0..<gridDimension).allSatisfy({ gameBoard[$0][i] == player }) {
                return (0..<gridDimension).map { ($0, i) }
            }
        }
        
        if (0..<gridDimension).allSatisfy({ gameBoard[$0][$0] == player }) {
            return (0..<gridDimension).map { ($0, $0) }
        }
        
        if (0..<gridDimension).allSatisfy({ gameBoard[$0][gridDimension - 1 - $0] == player }) {
            return (0..<gridDimension).map { ($0, gridDimension - 1 - $0) }
        }
        
        return nil
    }
    
    private func isBoardFull() -> Bool {
        return gameBoard.flatMap { $0 }.allSatisfy { $0 != nil }
    }
    
    private func highlightWinningCombination(_ combination: [(Int, Int)]) {
        for (row, col) in combination {
            squares[row][col].backgroundColor = .green
        }
    }
    
    public func resetGame() {
        gameBoard = Array(repeating: Array(repeating: nil, count: 3), count: 3)
        currentPlayer = .x
        for row in squares {
            for square in row {
                square.subviews.forEach { $0.removeFromSuperview() }
                square.backgroundColor = cellColor
            }
        }
    }
}

public enum Player: String {
    case x = "X"
    case o = "O"
}
