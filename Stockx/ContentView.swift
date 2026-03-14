import SwiftUI

//Models
struct Banner: Identifiable, Hashable { let id = UUID(); let imageName: String }
struct Product: Identifiable, Hashable { let id = UUID(); let title: String; let subtitle: String; let price: String; let imageName: String }
struct CategoryItem: Identifiable, Hashable { let id = UUID(); let title: String; let imageName: String }

// ViewModels
@Observable
final class ShopViewModel {
    var banners: [Banner] = [
        Banner(imageName: "photo"),
        Banner(imageName: "bolt.fill"),
        Banner(imageName: "flame.fill")
    ]

    var recommended: [Product] = [
        Product(title: "Air Max 97", subtitle: "Silver Bullet", price: "$199", imageName: "shoeprints.fill"),
        Product(title: "Jordan 1", subtitle: "Chicago", price: "$299", imageName: "shoeprints.fill"),
        Product(title: "Yeezy 350", subtitle: "Zebra", price: "$249", imageName: "shoeprints.fill")
    ]

    var categories: [CategoryItem] = [
        CategoryItem(title: "Sneakers", imageName: "shoeprints.fill"),
        CategoryItem(title: "Apparel", imageName: "tshirt.fill"),
        CategoryItem(title: "Accessories", imageName: "bag.fill"),
        CategoryItem(title: "New", imageName: "sparkles"),
        CategoryItem(title: "Sale", imageName: "percent")
    ]
}

//
struct ContentView: View {
    @State private var shopVM = ShopViewModel()

    var body: some View {
        TabView {
            ShopHomeView(shopVM: shopVM)
                .tabItem { Label("", systemImage: "xmark") }
            Text("Search")
                .tabItem { Label("", systemImage: "magnifyingglass") }
            Text("Favorites")
                .tabItem { Label("", systemImage: "heart") }
            Text("Alerts")
                .tabItem { Label("", systemImage: "bell") }
            Text("Profile")
                .tabItem { Label("", systemImage: "person") }
        }
    }
}

struct ShopHomeView: View {
    var shopVM: ShopViewModel
    @State private var bannerIndex = 0

    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    // Banner carousel
                    TabView(selection: $bannerIndex) {
                        ForEach(Array(shopVM.banners.enumerated()), id: \.element) { index, banner in
                            ZStack {
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.gray.opacity(0.15))
                                Image(systemName: banner.imageName)
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundStyle(.primary)
                                    .padding(40)
                            }
                            .frame(height: 160)
                            .padding(.horizontal)
                            .tag(index)
                        }
                    }
                    .tabViewStyle(.page(indexDisplayMode: .automatic))
                    .frame(height: 180)

                    // Recommended For You
                    Text("Recommended For You")
                        .font(.title2).bold()
                        .padding(.horizontal)

                    TabView {
                        ForEach(shopVM.recommended) { product in
                            ProductCardView(product: product)
                                .padding(.vertical, 4)
                                .padding(.horizontal, 12)
                        }
                    }
                    .tabViewStyle(.page(indexDisplayMode: .automatic))
                    .frame(height: 250)

                    // Shop by Category
                    Text("Shop by Category")
                        .font(.title2).bold()
                        .padding(.horizontal)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(shopVM.categories) { category in
                                CategorySquareView(category: category)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom)
                    }
                }
                .padding(.top)
            }
            .navigationTitle("Shop")
        }
    }
}

struct ProductCardView: View {
    let product: Product

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            RoundedRectangle(cornerRadius: 16)
                .fill(LinearGradient(colors: [.gray.opacity(0.15), .gray.opacity(0.05)], startPoint: .top, endPoint: .bottom))
            VStack(alignment: .leading, spacing: 8) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(product.title)
                            .font(.headline)
                        Text(product.subtitle)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    Image(systemName: product.imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                        .foregroundStyle(.primary)
                }
                Spacer()
                HStack {
                    Text(product.price)
                        .font(.title3).bold()
                    Spacer()
                    Button {
                        // Add to cart action
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(16)
        }
        .frame(height: 220)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
}

struct CategorySquareView: View {
    let category: CategoryItem

    var body: some View {
        VStack(spacing: 10) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.12))
                Image(systemName: category.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 36, height: 36)
                    .foregroundStyle(.primary)
            }
            .frame(width: 100, height: 100)

            Text(category.title)
                .font(.footnote)
                .foregroundStyle(.primary)
        }
        .frame(width: 100)
    }
}

#Preview {
    ContentView()
}
