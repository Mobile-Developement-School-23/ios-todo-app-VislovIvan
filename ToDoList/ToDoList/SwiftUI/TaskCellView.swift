import SwiftUI

struct TaskView: View {
    @Binding var task: TodoItemSwiftUI
    @Binding var showFinishedTasks: Bool
    
    var body: some View {
        HStack {
            Image(systemName: task.isFinished ? "checkmark.circle.fill" : "circle")
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundColor(task.isFinished ? .green : (task.importance == .important ? .red : .gray))
                .onTapGesture {
                    
                    // анимация работает, но криво и не очень красиво
//                    withAnimation {
                        task.isFinished.toggle()
                        if task.isFinished {
                            showFinishedTasks = false
                        }
//                    }
                }
            
            if task.importance == .important && !task.isFinished {
                Image("imagePriorityUp")
            } else if task.importance == .unimportant && !task.isFinished {
                Image("imagePriorityDown")
            }
            
            VStack(alignment: .leading, spacing: 5) {
                Text(task.text)
                    .font(.body)
                    .strikethrough(task.isFinished)
                    .foregroundColor(task.isFinished ? .gray : .primary)
                    .lineLimit(3)
                if let deadline = task.deadline, !task.isFinished {
                    HStack {
                        Image(systemName: "calendar")
                            .foregroundColor(.gray)
                        Text("\(deadline, formatter: DateFormatter.dateFormatter)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
            }
            Spacer()
        }
        .padding(.leading, 0)
        .padding(.vertical, 8)
        .contentShape(Rectangle())
    }
}
