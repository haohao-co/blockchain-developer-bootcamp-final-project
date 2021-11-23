const NftTradingPlatform = artifacts.require("./NftTradingPlatform.sol");

contract("NftTradingPlatform", accounts => {
    const [kevin, bob] = accounts;
    let instance;

    beforeEach(async () => {
        instance = await NftTradingPlatform.new();
    })

    describe("Variables", () => {
        it("should have an owner", async () => {
            assert.equal(typeof instance.owner, 'function', "the contract has no owner");
        });
    })

    describe("Use cases", () => {
        ///test single token creation
        it("should create a token", async () => {
            await instance.createToken("https://testnets.opensea.io/test");
            ///fetch created tokens
            const items = await instance.getItems();

            assert.equal(items[0][0], 10001, "Token is not created");
        });

        it("should have a correct price on multiple token", async () => {
            await instance.createToken("https://testnets.opensea.io/test1");
            await instance.createToken("https://testnets.opensea.io/test2");
            const items = await instance.getItems();

            assert.equal(items[1][1], 5, "the token do not have correct default price");
        });

        it("should be able to reset price for given token", async () => {
            await instance.createToken("https://testnets.opensea.io/test1");
            await instance.setTokenPrice(10001, 100);
            const items = await instance.getItems();

            assert.equal(items[0][1], 100, "fail to reset token price");
        });

        it("should have correct owner", async () => {
            await instance.createToken("https://testnets.opensea.io/test1", { from: kevin });
            const items = await instance.getItems();

            assert.equal(items[0][2], kevin, "fail to set correct owner");
        });

        it("should support buy operation", async () => {
            await instance.createToken("https://testnets.opensea.io/test1", { from: kevin });
            await instance.buy(10001, { from: bob, value: 5 })

            const items = await instance.getItems();

            assert.equal(items[0][2], bob, "fail to buy token");
        });
    })
});
