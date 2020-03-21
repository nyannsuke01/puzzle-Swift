//
//  ViewController.swift
//  pzz9
//
//  Created by user on 2020/03/10.
//  Copyright © 2020 user. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var button0: UIButton!
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    @IBOutlet weak var button5: UIButton!
    @IBOutlet weak var button6: UIButton!
    @IBOutlet weak var button7: UIButton!
    @IBOutlet weak var button8: UIButton!
    @IBOutlet weak var colorView: UIView!
    //ボタンをUIButtonl型で初期化
    var buttons = [UIButton]()
    //ポイントをCGポイント型で初期化
    var points = [CGPoint]()
    //mapを二次元配列UIButtonl型で初期化
    var map = [[UIButton]]()

    override func viewDidLoad() {
        super.viewDidLoad()

        buttons.append(button0)
        buttons.append(button1)
        buttons.append(button2)
        buttons.append(button3)
        buttons.append(button4)
        buttons.append(button5)
        buttons.append(button6)
        buttons.append(button7)
        buttons.append(button8)

        for button in buttons {
            points.append(button.frame.origin)
        }
        reset()
    }

    @IBAction func moveButton(_ button: UIButton) {
        //ここで二次元配列にしたyの値が0になっている。
        for y in 0..<map.count {
            for x in 0..<map[y ].count {
                if map[y][x].tag == button.tag {
                    searchAndMove(x: x, y: y)
                    return
                }
            }
        }
    }

    @IBAction func startButton(_ button: UIButton) {
        reset()
    }

    //リセットメソッドviewDidLoad時に呼ばれる
    private func reset(){
        colorView.isHidden = true
        button8.isHidden = true
        buttons = buttons.shuffled()

        for button in buttons {
            points.append(button.frame.origin)
        }

        for index in 0..<buttons.count {
            buttons[index].frame.origin = points[index]
        }
        //ボタンを二次元配列で配置
        map = [[UIButton]]()
        map.append([buttons[0], buttons[1], buttons[2]])
        map.append([buttons[3], buttons[4], buttons[5]])
        map.append([buttons[6], buttons[7], buttons[8]])
    }

    //hiddenにしていたbutton8を探して入れ替える
    private func searchAndMove(x: Int, y: Int) {
        //左
        if x - 1 >= 0, map[y][x - 1] == button8 {
            xMove(beginX: x, endX: x - 1, y: y)
        //右
        } else if x + 1 <= 2, map[y][x + 1] == button8 {
            xMove(beginX: x, endX: x + 1, y: y)
        //下
        } else if y - 1 >= 0, map[y - 1][x] == button8 {
            yMove(x: x,beginY: y, endY: y - 1)
        //上
        } else if y + 1 <= 2, map[y + 1][x] == button8 {
            yMove(x: x, beginY: y, endY: y + 1)
        }
    }

    //x座標の動き
    private func xMove(beginX: Int, endX: Int, y: Int) {
        UIView.animate(withDuration: 0.2, animations: {
            //座標の入れ替え
            let origin = self.map[y][endX].frame.origin
            self.map[y][endX].frame.origin = self.map[y][beginX].frame.origin
            self.map[y][beginX].frame.origin = origin
        }, completion: { _ in
            //ボタンの入れ替え
            let button = self.map[y][endX]
            self.map[y][endX] = self.map[y][beginX]
            self.map[y][beginX] = button
            self.judge()
        })
    }
    //y座標の動き
    private func yMove(x: Int,beginY: Int, endY: Int) {
        UIView.animate(withDuration: 0.2, animations: {
            //座標の入れ替え
            let origin = self.map[endY][x].frame.origin
            self.map[endY][x].frame.origin = self.map[beginY][x].frame.origin
            self.map[beginY][x].frame.origin = origin
        }, completion: { _ in
            //ボタンの入れ替え
            let button = self.map[endY][x]
            self.map[endY][x] = self.map[beginY][x]
            self.map[beginY][x] = button
            self.judge()
        })
    }

    //クリア判定　mapの位置
    private func judge() {
        if map[0][0] == button0, map[0][1] == button1, map[0][2] == button2,
            map[1][0] == button3, map[1][1] == button4, map[1][2] == button5,
            map[2][0] == button6, map[2][1] == button7, map[2][2] == button8{
            colorView.isHidden = false
            button8.isHidden = false

            let alert = UIAlertController(title: "クリア",message: "おめでとう！", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(alertAction)
            present(alert, animated: true, completion: nil)
        }
    }
}

