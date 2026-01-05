import { PrismaClient } from "@prisma/client";
import bcrypt from "bcrypt";

const prisma = new PrismaClient();

class AdminService {
  async createAdmin(username: string, password: string) {
    const hashedPassword = await bcrypt.hash(password, 10);

    const admin = await prisma.admin.create({
      data: {
        username,
        password: hashedPassword,
      },
    });

    return admin;
  }

  async loginAdmin(username: string, password: string) {
    const admin = await prisma.admin.findUnique({
      where: { username },
    });

    if (!admin) {
      throw new Error("Admin not found");
    }

    const isPasswordValid = await bcrypt.compare(password, admin.password);

    if (!isPasswordValid) {
      throw new Error("Invalid password");
    }

    return admin;
  }

  async getAdmin(adminId: number) {
    const admin = await prisma.admin.findUnique({
      where: { id: adminId },
    });
    return admin;
  }

  async updateAdmin(
    adminId: number,
    data: { username?: string; password?: string }
  ) {
    let updateData: any = { ...data };

    if (data.password) {
      updateData.password = await bcrypt.hash(data.password, 10);
    }

    const updatedAdmin = await prisma.admin.update({
      where: { id: adminId },
      data: updateData,
    });

    return updatedAdmin;
  }

  async deleteAdmin(adminId: number) {
    await prisma.admin.delete({
      where: { id: adminId },
    });
    return { message: "Admin deleted successfully" };
  }
}

export default new AdminService();
