import {
  describe,
  it,
  expect,
  beforeEach
} from "vitest";

import {
  render,
  screen
} from "@testing-library/react";

import {
  MemoryRouter
} from "react-router-dom";

import {
  AuthProvider
} from "../src/context/AuthContext";

import Dashboard from "../src/pages/Dashboard";

describe("Dashboard Page", () => {
  beforeEach(() => {
    localStorage.clear();
    localStorage.setItem(
      "token",
      "demo-token"
    );
  });

  it("renders dashboard content", async () => {
    render(
      <MemoryRouter>
        <AuthProvider>
          <Dashboard />
        </AuthProvider>
      </MemoryRouter>
    );

    expect(
      await screen.findByText("Dashboard")
    ).toBeInTheDocument();

    expect(
      screen.getByText("Applications")
    ).toBeInTheDocument();

    expect(
      screen.getByText("Active Servers")
    ).toBeInTheDocument();

    expect(
      screen.getByText("Security Status")
    ).toBeInTheDocument();

    expect(
      screen.getByText("Pipelines")
    ).toBeInTheDocument();
  });
});