# TicTacToe-SPM

TicTacToe-SPM представляет собой пакет для игры в крестики-нолики, реализованный с использованием Swift Package Manager (SPM). Этот пакет предоставляет настраиваемую реализацию игры в крестики-нолики с возможностью изменения цвета клеток и функциональностью для сброса игры.

## Установка и интеграция

1. Для установки выполните следующие шаги:

   Добавьте пакет в зависимости вашего проекта, перейдя в файл проекта на вкладке «Зависимости пакета» и щелкнув значок «плюс».

   Добавление пакета - https://github.com/AnnaNikolS/TicTacToeGame.git

2. В открывшемся окне введите ссылку на Git-репозиторий, где находится пакет. Выберите «До следующей основной версии» в поле «Правило зависимостей» и укажите текущую версию пакета как «1.0.0». После этого нажмите кнопку «Добавить пакет».

3. После успешного добавления пакета в ваш проект вы увидите его в иерархии вашего проекта.

4. Используйте пакет в своем проекте. Ниже представлен код для демонстрации работы пакета:

   ```swift
   import UIKit
   import TicTacToePackage

   class ViewController: UIViewController {
       private var ticTacToeView: TicTacToeView!

       override func viewDidLoad() {
           super.viewDidLoad()

           ticTacToeView = TicTacToeView(frame: view.bounds, cellColor: .lightGray)
           ticTacToeView.delegate = self
           view.addSubview(ticTacToeView)
       }
   }

   extension ViewController: TicTacToeViewDelegate {
       func gameDidEnd(withMessage message: String) {
           let alert = UIAlertController(title: "Game Over", message: message, preferredStyle: .alert)
           alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
           present(alert, animated: true, completion: nil)
       }
   }
