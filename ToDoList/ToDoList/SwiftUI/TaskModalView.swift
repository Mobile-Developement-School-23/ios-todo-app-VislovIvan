import SwiftUI

struct TodoModalViewSwiftUI: View {
    @Binding var todoText: String
    @State private var date: Date = Date()
    @State private var importance: ImportanceSwiftUI = .normal
    @State private var showDatePicker: Bool = false
    @State private var selectedColor: Color = .black
    
    var body: some View {
        NavigationView {
            ZStack {
                
                // для тёмной темы не адаптировано и не совсем те цвета
                Color("backiOSPrimary").edgesIgnoringSafeArea(.all)
                VStack(spacing: 0) {
                    
                    // расширяется не как в макете, а просто внутри TextEditor scroll view
                    // но написать что-то можно
                    TextEditor(text: $todoText)
                        .padding(12)
                        .background(Color.white)
                        .cornerRadius(16)
                        .frame(maxHeight: 120)
                        .padding(.horizontal, 20)
                        .padding(.top, 16)
                    List {
                        VStack {
                            HStack(spacing: 80) {
                                Text("Важность")
                                Picker("Важность", selection: $importance) {
                                    
                                    // в селектор не передается статус важности из модели, также и в календарь дата
                                    Image("imagePriorityDown").tag(ImportanceSwiftUI.unimportant)
                                    Text("нет").tag(ImportanceSwiftUI.normal)
                                    Image("imagePriorityUp").tag(ImportanceSwiftUI.important)
                                }
                                .pickerStyle(SegmentedPickerStyle())
                            }
                        }
                        .padding(.vertical, 4)
                        
                        VStack {
                            Toggle("Сделать до", isOn: $showDatePicker)
                        }
                        .padding(.vertical, 4)
                        
                        // picker тоже не 1в1 как в макете
                        if showDatePicker {
                            DatePicker("Дата", selection: $date, displayedComponents: .date)
                        }
                        
                        // отсутсвует кнопка сохранить
                        
                    }
                }
                .navigationTitle("Дело")
                .navigationBarTitleDisplayMode(.inline)
                
                // кнопки пустные, без действий
                .navigationBarItems(leading: Button("Отменить", action: {
                }), trailing: Button("Сохранить", action: {
                    
                }))
            }
        }
    }
    
    var placeholder: some View {
        if todoText.isEmpty {
            return AnyView(Text("Что надо сделать?")
                .foregroundColor(.gray)
                .padding(.leading, 20)
            )
        } else {
            return AnyView(EmptyView())
        }
    }
}

struct TodoModalView_Previews: PreviewProvider {
    static var previews: some View {
        TodoModalViewSwiftUI(todoText: .constant(""))
    }
}
