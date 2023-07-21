import SwiftUI

#if DEV
    let baseURL = "Dev"
#else
    let baseURL = "Prod"
#endif

struct TodoListView: View {
    @State var tasks: [TodoItemSwiftUI]
    @State private var showFinishedTasks = true
    @State private var showingModal = false
    @State private var selectedTaskText = ""
    
    var finishedTasksCount: Int {
        tasks.filter { $0.isFinished }.count
    }
    
    var filteredTasks: [TodoItemSwiftUI] {
        tasks.filter { !($0.isFinished && !showFinishedTasks) }
    }
    
    // констрейнты не 1в1 как в макете
    var body: some View {
        NavigationView {
            ZStack {
                Color("backiOSPrimary").edgesIgnoringSafeArea(.all)
                VStack(spacing: 0) {
                    HStack {
                        Text("Выполнено - \(finishedTasksCount)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .padding(.leading)
                            .padding(.top, 15)
                        Spacer()
                        
                        Button(action: {
                            showFinishedTasks.toggle()
                        }, label: {
                            Text(showFinishedTasks ? "Скрыть" : "Показать")
                        })
                        .padding(.trailing)
                    }
                    
                    List(filteredTasks, id: \.id) { task in
                        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
                            TaskView(task: $tasks[index], showFinishedTasks: $showFinishedTasks)
                                .onTapGesture {
                                    selectedTaskText = task.text
                                    showingModal = true
                                }
                            
                            // удалить и отметить сделанным можно, но понятно, что в мок формате
                                .swipeActions(edge: .leading, allowsFullSwipe: true) {
                                    Button(action: {
                                        tasks[index].isFinished.toggle()
                                        // тут и на экшенах ниже ругается на Multiple Closures
                                    }) {
                                        Image(systemName: "checkmark.circle.fill")
                                    }
                                    .tint(.green)
                                }
                                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                    Button(action: {
                                        tasks.remove(at: index)
                                    }) {
                                        Image(systemName: "trash")
                                    }
                                    .tint(.red)

                                    Button(action: {
                                        // Additional action if needed
                                    }) {
                                        Image(systemName: "info.circle.fill")
                                    }
                                }
                        }
                    }

                    .navigationBarTitle("Мои дела", displayMode: .large)
                }
            }
            .sheet(isPresented: $showingModal) {
                TodoModalViewSwiftUI(todoText: $selectedTaskText)
            }
        }
        let _ = print(baseURL)
    }
}

struct TodoListView_Previews: PreviewProvider {
    static var previews: some View {
        // мок для первью
        TodoListView(tasks: [
            TodoItemSwiftUI(
                text: "Купить что-то",
                importance: .normal,
                deadline: nil,
                isFinished: true
            ),
            TodoItemSwiftUI(
                text: "Купить что-то",
                importance: .normal,
                deadline: nil,
                isFinished: false
            ),
            TodoItemSwiftUI(
                text: "Купить что-то",
                importance: .unimportant,
                deadline: Date(timeIntervalSince1970: 1688241600),
                isFinished: false
            ),
            TodoItemSwiftUI(
                text: "Купить что-то",
                importance: .important,
                deadline: Date(timeIntervalSince1970: 1688500800),
                isFinished: false
            ),
            TodoItemSwiftUI(
                text: "Задание",
                importance: .important,
                deadline: nil,
                isFinished: true
            ),
            TodoItemSwiftUI(
                text: "Купить что-то, где-то, зачем-то, но зачем не очень понятно, но точно чтобы что-то, где-то, зачем-то, но зачем не очень понятно, но точно чтобы",
                importance: .normal,
                deadline: Date(timeIntervalSince1970: 1688500800),
                isFinished: false
            ),
            TodoItemSwiftUI(
                text: "Купить сыр",
                importance: .unimportant,
                deadline: nil,
                isFinished: false
            ),
            TodoItemSwiftUI(
                text: "сделать зарядку",
                importance: .important,
                isFinished: true,
                createdAt: Date(timeIntervalSince1970: 1688241600),
                changedAt: Date(timeIntervalSince1970: 1688241600)
            )
        ])
    }
}
