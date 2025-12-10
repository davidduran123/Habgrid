import WidgetKit
import SwiftUI

/*
 
 Quick context:
 
 - struct: a lightweight class with variables and methods
 - let: defines a final immutable variable
 - var: a mutable variable
 
*/

// Class type that feeds widget data over time, methods in here are called by WidgetKit to get entries.

struct Provider: TimelineProvider {
    
    func placeholder(in context: Context) -> SimpleEntry {
 
        SimpleEntry(
            
            date: Date(),
            emoji: "😀",
            habits: ["W", "L", "R","P"],
            days: daysForCurrentMonth()
            
        )
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        
        let entry = SimpleEntry(
            
            date: Date(),
            emoji: "😀",
            habits: ["W", "L", "R", "P"],
            days: daysForCurrentMonth()
            
        )
        
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        
        let currentDate = Date()
        let habits = ["W", "L", "R", "P"] // later: load from user defaults
        let days = daysForCurrentMonth()
    
        var entries: [SimpleEntry] = []
        
        for hourOffset in 0 ..< 5 {
            
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            
            let entry = SimpleEntry(
                
                date: entryDate,
                emoji: "😀",
                habits: habits,
                days: days
                
            )
            
            entries.append(entry)
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
        
    }
    
    // Determines and returns the number of days in a given month.
    private func daysForCurrentMonth() -> [Int] {
        
        let calendar = Calendar.current
        let today = Date()
        
        if let range = calendar.range(of: .day, in: .month, for: today) {
            return Array(range)
        }
        else {
            return Array(1...30)
        }
    }
}

// Class that serves as a data model for WidgetKit.
struct SimpleEntry: TimelineEntry {
    let date: Date
    let emoji: String
    let habits: [String]
    let days: [Int]
}


// Draws the widget's UI.
struct HabgridWidgetEntryView : View {
    
    var entry: Provider.Entry

    var body: some View {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 15) {
                    Text(entry.date.formatted(.dateTime.month(.wide)))
                        .font(.caption.bold())

                    ForEach(entry.habits, id: \.self) { habit in
                        HStack(spacing: 2) {
                            Text(habit)
                                .font(.system(size: 8).bold())
                                .frame(width: 10, alignment: .leading)

                            ForEach(entry.days, id: \.self) { day in
                                RoundedRectangle(cornerRadius: 0, style: .continuous)
                                    .fill(Color.blue)
                                    .frame(width: 8, height: 8)
                            }
                        }
                    }
                }
                .padding(0)

                Spacer()   // pushes content to use available width
            }
        }
}


// Class that declares the widget and tells the system how to display it.

struct HabgridWidget: Widget {
    
    let kind: String = "HabgridWidget"

    var body: some WidgetConfiguration {
        
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                HabgridWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                HabgridWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
        .supportedFamilies([.systemMedium])
    }
}


// Previews the widget.

#Preview(as: .systemMedium) {
    HabgridWidget()
} timeline: {
    SimpleEntry(
        date: .now,
        emoji: "😀",
        habits: ["W", "L", "R", "P"],
        days: Array(1...31)
    )
    SimpleEntry(
        date: .now,
        emoji: "🤩",
        habits: ["W", "L", "R", "P"],
        days: Array(1...31)
    )
}
