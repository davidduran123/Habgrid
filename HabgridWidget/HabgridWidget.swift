//
//  HabgridWidget.swift
//  HabgridWidget
//
//  Created by David Duran Fuentes on 2025-12-02.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), emoji: "😀")
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), emoji: "😀")
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, emoji: "😀")
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }

//    func relevances() async -> WidgetRelevances<Void> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let emoji: String
}

struct HabgridWidgetEntryView : View {
    var entry: Provider.Entry

        let habits = ["W", "L", "R"]
        let days = Array(1...7)

        var body: some View {
            VStack(alignment: .leading, spacing: 6) {
                Text("December")
                    .font(.caption.bold())

                ForEach(habits, id: \.self) { habit in
                    HStack(spacing: 4) {
                        Text(habit.prefix(3))
                            .font(.system(size: 10).bold())
                            .frame(width: 26, alignment: .leading)

                        ForEach(days, id: \.self) { day in
                            Circle()
                                .fill(day % 2 == 0 ? Color.green : Color.gray.opacity(0.3))
                                .frame(width: 14, height: 14)
                        }
                    }
                }
            }
            .padding(8)
            .background(Color(.systemGray6))
        }
}

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
    }
}

#Preview(as: .systemSmall) {
    HabgridWidget()
} timeline: {
    SimpleEntry(date: .now, emoji: "😀")
    SimpleEntry(date: .now, emoji: "🤩")
}
