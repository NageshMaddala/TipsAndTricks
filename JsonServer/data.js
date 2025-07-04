export default () => {
    const data = {
        products: [],
    }
    for (let i = 1; i <= 100; i++) {
        data.products.push({
            id: i,
            name: `Product ${i}`,
            description: `Description for product ${i}`,
            price: (Math.random() * 100).toFixed(2),
            category: `Category ${Math.ceil(i / 10)}`,
            inStock: Math.random() > 0.5
        });
        return data;
    }
}