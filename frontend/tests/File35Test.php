<?php
use PHPUnit\Framework\TestCase;
use Demo\File35;

class File35Test extends TestCase {
    public function testAdd() {
        $this->assertEquals(5, File35::add(2, 3));
    }
}
