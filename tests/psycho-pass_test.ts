import { Clarinet, Tx, Chain, Account, types } from "https://deno.land/x/clarinet/index.ts";

Clarinet.test({
  name: "Psycho-Pass basic flow test",
  async fn(chain: Chain, accounts: Map<string, Account>) {
    const deployer = accounts.get("deployer")!;
    const studentA = accounts.get("wallet_1")!;
    const studentB = accounts.get("wallet_2")!;

    const contractName = "psycho-pass";

    // 1. Check initial metadata
    let block = chain.mineBlock([
      Tx.contractCall(contractName, "get-name", [], deployer.address),
      Tx.contractCall(contractName, "get-symbol", [], deployer.address),
      Tx.contractCall(contractName, "get-decimals", [], deployer.address),
      Tx.contractCall(contractName, "get-total-supply", [], deployer.address)
    ]);
    block.receipts.map(r => r.result.expectOk());

    // 2. Mint 100 PPC to studentA
    block = chain.mineBlock([
      Tx.contractCall(contractName, "mint", [
        types.principal(studentA.address),
        types.uint(100_000000) // 100 PPC with 6 decimals
      ], deployer.address)
    ]);
    block.receipts[0].result.expectOk();

    // 3. Check balance studentA
    block = chain.mineBlock([
      Tx.contractCall(contractName, "get-balance", [types.principal(studentA.address)], deployer.address)
    ]);
    block.receipts[0].result.expectOk().expectUint(100_000000);

    // 4. Transfer 50 PPC from studentA to studentB
    block = chain.mineBlock([
      Tx.contractCall(contractName, "transfer", [
        types.uint(50_000000),
        types.principal(studentA.address),
        types.principal(studentB.address),
        types.none()
      ], studentA.address)
    ]);
    block.receipts[0].result.expectOk();

    // 5. Check balances
    block = chain.mineBlock([
      Tx.contractCall(contractName, "get-balance", [types.principal(studentA.address)], deployer.address),
      Tx.contractCall(contractName, "get-balance", [types.principal(studentB.address)], deployer.address)
    ]);
    block.receipts[0].result.expectOk().expectUint(50_000000);
    block.receipts[1].result.expectOk().expectUint(50_000000);

    // 6. Burn 20 PPC from studentB
    block = chain.mineBlock([
      Tx.contractCall(contractName, "burn", [
        types.principal(studentB.address),
        types.uint(20_000000)
      ], studentB.address)
    ]);
    block.receipts[0].result.expectOk();

    // 7. Psycho-Pass Threshold tests
    // Expect Clear (≥ 80 PPC)
    block = chain.mineBlock([
      Tx.contractCall(contractName, "get-psycho-pass-status", [types.principal(studentA.address)], deployer.address)
    ]);
    block.receipts[0].result.expectOk().expectAscii("Caution"); 
    // <-- ini contoh, nanti sesuaikan logika di kontrak

    // 8. Edge case: transfer lebih dari saldo
    block = chain.mineBlock([
      Tx.contractCall(contractName, "transfer", [
        types.uint(999_000000),
        types.principal(studentA.address),
        types.principal(studentB.address),
        types.none()
      ], studentA.address)
    ]);
    block.receipts[0].result.expectErr();
  }
});
