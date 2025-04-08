<?php
use PHPUnit\Framework\TestCase;
use Demo\File95;

class File95Test extends TestCase {
    public function testAdd() {
        $this->assertEquals(5, File95::add(2, 3));
    }
}
