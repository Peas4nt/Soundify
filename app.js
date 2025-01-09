import express from "express";
import session from "express-session";
import path from "path";
import bodyParser from "body-parser";
import dotenv from 'dotenv';
import { dbTest } from "./db.js";
import routes from "./src/routes/defaultRoutes.js";

dotenv.config();
const app = express();
const port = process.env.SERVER_PORT ?? 3000;
const __dirname = path.join();

// configure a view engine ejs
app.set("view engine", "ejs");
app.set("views", path.join(__dirname, "/src/views"));

// open the public folder
app.use(express.static(path.join(__dirname, "public")));

// configure session
app.use(session({
	secret: '123312qwerty',
	resave: false,
	saveUninitialized: false,
	cookie: { secure: false }
}));

app.use(bodyParser.urlencoded({ extended: true }));

// routes using
app.use("/", routes);

async function start() {
	// test db connection
	if (await dbTest()) {
		// start server
		app.listen(port, () => {
			console.log("Server listening on port: " + port);
			console.log(`http://localhost:${port}/`);
		});
	}
}

start();
