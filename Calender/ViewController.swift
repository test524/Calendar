//
//  ViewController.swift
//  Calender
//
//  Created by Pavan Kumar Reddy on 02/12/17.
//  Copyright © 2017 Pavan. All rights reserved.
//

import UIKit
import JTAppleCalendar

class ViewController: UIViewController
{

    @IBOutlet var barButtontoDay: UIBarButtonItem!
    @IBOutlet var calenderView: JTAppleCalendarView!
    @IBOutlet var barButtonYear: UIBarButtonItem!
    @IBOutlet var barButtonMonth: UIBarButtonItem!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        setupCalenserView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        calenderView.visibleDates { (visibleDates) in
            self.setMonthAndDates(from: visibleDates)
        }
    }
    
    func setupCalenserView()
    {
        calenderView.scrollToDate(Date(), triggerScrollToDateDelegate: false, animateScroll: false, preferredScrollPosition: .none, extraAddedOffset: 0) {

        }
    }
    
    @IBAction func goToTodayDate(_ sender: UIBarButtonItem)
    {
        if let _ = calenderView.visibleDates().monthDates.first?.date
        {
            calenderView.scrollToDate(Date(), triggerScrollToDateDelegate: true, animateScroll: false, preferredScrollPosition: .none, extraAddedOffset: 0, completionHandler: nil)
        }
    }

    //MARK:- DateFormat
    let customDateFormat:DateFormatter  = {
        let obj = DateFormatter()
            obj.dateFormat = "yyyy MM dd"
            obj.timeZone = Calendar.current.timeZone
            obj.locale = Calendar.current.locale
        return obj
    }()
    
    //MARK:- Cell circle selection
    func handleCellSelected(view:JTAppleCell? , cellState:CellState)
    {
        guard let validCell = view as? CustomeCell else {
            return
        }
        
        if validCell.isSelected
        {
            validCell.circleView.isHidden = false
        }
        else
        {
            validCell.circleView.isHidden = true
        }
    }
    
    //MARK:- Cell Text
    func handleCellSelectionTextColor(view:JTAppleCell? , cellState:CellState)
    {
        guard let validCell = view as? CustomeCell else {
            return
        }
        
        if validCell.isSelected
        {
            validCell.lblDate.textColor = .black
        }
        else
        {
            if cellState.dateBelongsTo == .thisMonth
            {
                validCell.lblDate.textColor = .white
            }
            else
            {
                validCell.lblDate.textColor = UIColor.darkGray
            }
        }
    }
    
    func selectTodayDate(view:JTAppleCell? , cellState:CellState)
    {
        
        guard let cell = view as? CustomeCell else {
            return
        }
        customDateFormat.dateFormat = "yyyy MM dd"
        
        let str1 = customDateFormat.string(from: cellState.date)
        let str2 = customDateFormat.string(from: Date())
        
        if str1 == str2
        {
            cell.circleView.isHidden = false
            cell.circleView.backgroundColor = UIColor.darkText
            cell.lblDate.textColor = self.view.tintColor
        }
    }
    
    //MARK:- Year and Month
    func setMonthAndDates(from visibleDates:DateSegmentInfo)
    {
        let date = visibleDates.monthDates.first!.date
        customDateFormat.dateFormat = "yyyy"
        barButtonYear.title = customDateFormat.string(from: date)
        
        customDateFormat.dateFormat = "MMMM"
        barButtonMonth.title = customDateFormat.string(from: date)
    }
    
}

extension ViewController: JTAppleCalendarViewDataSource
{
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters
    {
        let startDate = customDateFormat.date(from: "1990 01 01")!
        let endDate = customDateFormat.date(from: "3000 12 31")!
        let parameters = ConfigurationParameters.init(startDate: startDate, endDate: endDate)
        return parameters
    }
}

extension ViewController: JTAppleCalendarViewDelegate
{
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell
    {
        
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CustomeCell", for: indexPath) as! CustomeCell
        cell.lblDate.text = cellState.text
        
        handleCellSelected(view: cell, cellState: cellState)
        handleCellSelectionTextColor(view: cell, cellState: cellState)
        
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState)
    {
        handleCellSelected(view: cell, cellState: cellState)
        handleCellSelectionTextColor(view: cell, cellState: cellState)
        
        guard let validCell = cell as? CustomeCell else {
            return
        }
        
        validCell.lblDate.animateBounceEffect()
        validCell.circleView.animateBounceEffect()
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState)
    {
        
        handleCellSelected(view: cell, cellState: cellState)
        handleCellSelectionTextColor(view: cell, cellState: cellState)
        //selectTodayDate(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo)
    {
        setMonthAndDates(from: visibleDates)
    }
}


extension UIView
{
    func animateBounceEffect()
    {
        self.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        UIView.animate(
            withDuration: 0.5,
            delay: 0, usingSpringWithDamping: 0.3,
            initialSpringVelocity: 0.1,
            options: UIViewAnimationOptions.beginFromCurrentState,
            animations: {
                self.transform = CGAffineTransform(scaleX: 1, y: 1)
        },
            completion: nil
        )
    }
    
    func animatefadeOutEffect()
    {
        UIView.animate(withDuration: 0.6,
                       delay: 0, usingSpringWithDamping: 0.6,
                       initialSpringVelocity: 0,
                       options: [],
                       animations: {
                        self.alpha = 0
        },
                       completion: nil)
    }
    
    func animate3DTransformation(angle:Double) -> CATransform3D
    {
        var transformObj = CATransform3DIdentity
        transformObj.m34 = -1.0 / 500.0
        transformObj = CATransform3DRotate(transformObj,CGFloat(angle * .pi / 180.0), 0, 1, 0.0)
        return transformObj
    }
    
    func animateflipAnimation()
    {
        let angle = 180.0
        self.layer.transform = animate3DTransformation(angle: angle)
        UIView.animate(withDuration: 1,
        delay: 0,
        usingSpringWithDamping: 0.5,
        initialSpringVelocity: 0,
        options: [],
        animations: { () -> Void in
        self.layer.transform = CATransform3DIdentity
        },completion:nil)
    }
}
