//
//  JavaneseCalendarView.swift
//  JavaneseCalendar
//
//  Created by Dani Anggara on 24/04/25.
//

import SwiftUI

struct JavaneseCalendarView: View {
    @State private var selectedDate = Date()
    @State private var displayedMonth = Date()
    
    let pasaranDays = ["Legi", "Pahing", "Pon", "Wage", "Kliwon"]
    
    let pasaranNeptu = ["Legi": 5, "Pahing": 9, "Pon": 7, "Wage": 4, "Kliwon": 8]
    
    let weekdayNeptu: [String: Int] = [
        "Minggu": 5,
        "Senin": 4,
        "Selasa": 3,
        "Rabu": 7,
        "Kamis": 8,
        "Jumat": 6,
        "Sabtu": 9
    ]

    let javaneseMonths = [
        "Sura", "Sapar", "Mulud", "Bakda Mulud", "Jumadil Awal", "Jumadil Akhir",
        "Rejeb", "Ruwah", "Pasa", "Sawal", "Dulkangidah", "Besar"
    ]
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 22) {
                Text("Javanese Calendar")
                    .font(.largeTitle)
                    .bold()
                
                VStack(spacing: 16) {
                    HStack {
                        Button(action: {
                            displayedMonth = Calendar.current.date(byAdding: .month, value: -1, to: displayedMonth)!
                        }) {
                            Image(systemName: "chevron.left")
                        }
                        
                        Spacer()
                        
                        Text(monthYearString(for: displayedMonth))
                            .font(.title2)
                            .bold()
                        
                        Spacer()
                        
                        Button(action: {
                            displayedMonth = Calendar.current.date(byAdding: .month, value: 1, to: displayedMonth)!
                        }) {
                            Image(systemName: "chevron.right")
                        }
                    }
                    .padding(.horizontal)
                    
                    CalendarGrid(
                        selectedDate: $selectedDate,
                        displayedMonth: displayedMonth,
                        pasaranDays: pasaranDays,
                        highlightToday: true
                    )
                }
                
                Divider()
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Selected: \(formattedDate(selectedDate))")
                    Text("Pasaran: \(pasaran(for: selectedDate))")
                    Text("Weton: \(getWeton(for: selectedDate))")
                    Text("Neptu: \(getNeptu(for: selectedDate))")
                    Text("Javanese Month: \(javaneseMonth(for: selectedDate))")
                }
                .font(.subheadline)
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
            }
            .padding()
        }
    }
    
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "id_ID")
        formatter.dateStyle = .full
        return formatter.string(from: date)
    }

    func pasaran(for date: Date) -> String {
        let referenceDate = Calendar.current.date(from: DateComponents(year: 2023, month: 1, day: 1))! // Pon
        let dayDifference = Calendar.current.dateComponents([.day], from: referenceDate, to: date).day ?? 0
        let pasaranIndex = (dayDifference % 5 + 5) % 5
        return pasaranDays[pasaranIndex]
    }

    func getWeton(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "id_ID")
        formatter.dateFormat = "EEEE"
        let dayOfWeek = formatter.string(from: date)
        return "\(dayOfWeek) \(pasaran(for: date))"
    }

    func getNeptu(for date: Date) -> Int {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "id_ID")
        formatter.dateFormat = "EEEE"
        let dayOfWeek = formatter.string(from: date)
        let pas = pasaran(for: date)
        return (weekdayNeptu[dayOfWeek] ?? 0) + (pasaranNeptu[pas] ?? 0)
    }

    func javaneseMonth(for date: Date) -> String {
        let hijriCalendar = Calendar(identifier: .islamicUmmAlQura)
        let hijriMonth = hijriCalendar.component(.month, from: date)
        return javaneseMonths[hijriMonth - 1]
    }

    func monthYearString(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "id_ID")
        formatter.dateFormat = "LLLL yyyy"
        return formatter.string(from: date)
    }
}

#Preview {
    JavaneseCalendarView()
}
