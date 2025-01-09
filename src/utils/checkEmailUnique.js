import { sql } from "../../db.js";

export default async (email) => {
  const result = await sql`select 1 from users where email = ${email}`;
  return result.length > 0;
}