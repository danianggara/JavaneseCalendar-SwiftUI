//
//  CalendarGrid.swift
//  JavaneseCalendar
//
//  Created by Dani Anggara on 24/04/25.
//

import SwiftUI

struct CalendarGrid: View {
    @Binding var selectedDate: Date
    
    let displayedMonth: Date
    let pasaranDays: [String]
    let highlightToday: Bool

    var body: some View {
        let days = generateDays(for: displayedMonth)
        let currentDay = Calendar.current.component(.day, from: Date())
                
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7)) {
            ForEach(Calendar.current.shortWeekdaySymbols, id: \.self) { weekday in
                Text(weekday.prefix(2))
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            ForEach(days, id: \.self) { date in
                if Calendar.current.isDate(date, equalTo: displayedMonth, toGranularity: .month) {
                    let isToday = Calendar.current.isDateInToday(date)
                    let isSelected = Calendar.current.isDate(date, inSameDayAs: selectedDate)
                    
                    VStack {
                        Text("\(Calendar.current.component(.day, from: date))")
                            .font(.body)
                            .bold()
                        
                        Text(pasaran(for: date))
                            .font(.caption2)
                            .foregroundColor(.blue)
                    }
                    .frame(minHeight: 50)
                    .padding(4)
                    .background(
                        isSelected ? Color.blue.opacity(0.3)
                        : isToday ? Color.yellow.opacity(0.3)
                        : Color.clear
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .onTapGesture {
                        selectedDate = date
                    }
                } else {
                    Text("")
                        .frame(minHeight: 50)
                }
            }
        }
        .padding(.horizontal, 4)
    }

    func generateDays(for month: Date) -> [Date] {
        let calendar = Calendar.current
        var dates: [Date] = []

        guard let monthRange = calendar.range(of: .day, in: .month, for: month),
              let firstOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: month)) else {
            return dates
        }

        let weekday = calendar.component(.weekday, from: firstOfMonth)
        let leadingEmptyDays = (weekday + 6) % 7

        for _ in 0..<leadingEmptyDays {
            dates.append(Date.distantPast)
        }

        for day in monthRange {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: firstOfMonth) {
                dates.append(date)
            }
        }

        return dates
    }

    func pasaran(for date: Date) -> String {
        if date == Date.distantPast { return "" }
        let referenceDate = Calendar.current.date(from: DateComponents(year: 2023, month: 1, day: 1))! // Pon
        let dayDifference = Calendar.current.dateComponents([.day], from: referenceDate, to: date).day ?? 0
        let pasaranIndex = (dayDifference % 5 + 5) % 5
        return pasaranDays[pasaranIndex]
    }
}

