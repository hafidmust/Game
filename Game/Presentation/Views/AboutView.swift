import SwiftUI

struct AboutView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Profile Image
                    Image(systemName: "person.circle.fill")
                        .font(.system(size: 120))
                        .foregroundColor(.blue)
                    
                    // Developer Info
                    VStack(spacing: 8) {
                        Text("Hafid Ali Mustaqim")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Text("iOS Developer")
                            .font(.title3)
                            .foregroundColor(.secondary)
                    }
                    
                    // Bio
                    VStack(alignment: .leading, spacing: 16) {
                        Text("About Developer")
                            .font(.headline)
                        
                        Text("Passionate iOS developer with expertise in SwiftUI and Clean Architecture. Currently learning advanced iOS development through Dicoding iOS Expert learning path.")
                            .multilineTextAlignment(.leading)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    // Contact Info
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Contact Information")
                            .font(.headline)
                        
                        VStack(spacing: 12) {
                            ContactRowView(
                                icon: "envelope.fill",
                                title: "Email",
                                value: "hafidmust@example.com"
                            )
                            
                            ContactRowView(
                                icon: "phone.fill",
                                title: "Phone",
                                value: "+62 123 456 789"
                            )
                            
                            ContactRowView(
                                icon: "location.fill",
                                title: "Location",
                                value: "Indonesia"
                            )
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    // Skills
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Technical Skills")
                            .font(.headline)
                        
                        LazyVGrid(columns: [
                            GridItem(.adaptive(minimum: 100))
                        ], alignment: .leading, spacing: 8) {
                            ForEach(skills, id: \.self) { skill in
                                Text(skill)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(
                                        RoundedRectangle(cornerRadius: 16)
                                            .fill(Color.blue.opacity(0.2))
                                    )
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    // App Info
                    VStack(alignment: .leading, spacing: 16) {
                        Text("App Information")
                            .font(.headline)
                        
                        VStack(spacing: 8) {
                            HStack {
                                Text("Version:")
                                    .fontWeight(.semibold)
                                Spacer()
                                Text("1.0.0")
                            }
                            
                            HStack {
                                Text("Framework:")
                                    .fontWeight(.semibold)
                                Spacer()
                                Text("SwiftUI")
                            }
                            
                            HStack {
                                Text("Architecture:")
                                    .fontWeight(.semibold)
                                Spacer()
                                Text("Clean Architecture")
                            }
                            
                            HStack {
                                Text("Data Source:")
                                    .fontWeight(.semibold)
                                Spacer()
                                Text("RAWG API")
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("About")
        }
    }
    
    private let skills = [
        "Swift", "SwiftUI", "UIKit", "Combine", "Core Data",
        "MVVM", "Clean Architecture", "Unit Testing", "Git"
    ]
}

struct ContactRowView: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 20)
            
            VStack(alignment: .leading) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(value)
                    .fontWeight(.medium)
            }
            
            Spacer()
        }
    }
}

#Preview {
    AboutView()
} 