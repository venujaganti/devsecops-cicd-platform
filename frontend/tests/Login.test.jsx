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

import Login from "../src/pages/Login";

describe("Login Page", () => {
  beforeEach(() => {
    localStorage.clear();
  });

  it("renders the login page", () => {
    render(
      <MemoryRouter>
        <AuthProvider>
          <Login />
        </AuthProvider>
      </MemoryRouter>
    );

    expect(
      screen.getByRole("heading", {
        name: "DevSecOps Platform"
      })
    ).toBeInTheDocument();

    expect(
      screen.getByLabelText("Username")
    ).toBeInTheDocument();

    expect(
      screen.getByLabelText("Password")
    ).toBeInTheDocument();

    expect(
      screen.getByRole("button", {
        name: "Sign In"
      })
    ).toBeInTheDocument();
  });
});